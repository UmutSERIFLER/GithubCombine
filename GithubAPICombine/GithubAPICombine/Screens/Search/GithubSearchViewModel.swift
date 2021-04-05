//
//  GithubSearchViewModel.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 26/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

final class GithubSearchViewModel: GithubSearchViewModelType {

    private weak var navigator: GithubSearchNavigator?
    private let useCase: SearchUseCaseType
    private var cancellables: [AnyCancellable] = []

    init(useCase: SearchUseCaseType, navigator: GithubSearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: GithubSearchViewModelInput) -> GithubSearchViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input.selection
            .sink(receiveValue: { [unowned self] repoName in self.navigator?.showRepoDetails(for: repoName) })
            .store(in: &cancellables)

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        let repos = searchInput
            .filter({ !$0.isEmpty })
            .flatMapLatest({[unowned self] query in self.useCase.searchUsers(with: query) })
            .map({ result -> GithubSearchState in
                switch result {
                    case .success([]): return .noResults
                    case .success(let users): return .success(self.viewModels(from: users))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()

        let initialState: GithubSearchViewModelOutput = .just(.idle)
        let emptySearchString: GithubSearchViewModelOutput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
        let idle: GithubSearchViewModelOutput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

        return Publishers.Merge(idle, repos).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from users: [User]) -> [GithubViewModel] {
        return users.map({[unowned self] user in
            return GithubViewModelBuilder.viewModel(from: user, imageLoader: {[unowned self] repo in self.useCase.loadImage(for: repo) })
        })
    }

}
