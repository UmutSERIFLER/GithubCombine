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
    private let useCase: SeaarchUseCaseType
    private var cancellables: [AnyCancellable] = []

    init(useCase: SeaarchUseCaseType, navigator: GithubSearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: GithubSearchViewModelInput) -> GithubSearchViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        input.selection
            .sink(receiveValue: { [unowned self] repoId in self.navigator?.showDetails(forRepo: repoId) })
            .store(in: &cancellables)

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        let repos = searchInput
            .filter({ !$0.isEmpty })
            .flatMapLatest({[unowned self] query in self.useCase.searchRepos(with: query) })
            .map({ result -> GithubSearchState in
                switch result {
                    case .success([]): return .noResults
                    case .success(let repos): return .success(self.viewModels(from: repos))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()

        let initialState: GithubSearchViewModelOuput = .just(.idle)
        let emptySearchString: GithubSearchViewModelOuput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
        let idle: GithubSearchViewModelOuput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

        return Publishers.Merge(idle, repos).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from repos: [Repo]) -> [GithubViewModel] {
        return repos.map({[unowned self] repo in
            return GithubViewModelBuilder.viewModel(from: repo, imageLoader: {[unowned self] repo in self.useCase.loadImage(for: repo) })
        })
    }

}
