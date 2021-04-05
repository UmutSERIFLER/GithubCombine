//
//  UserRepoDetailsViewModel.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 27/03/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

class UserRepoDetailsViewModel: UserRepoDetailsViewModelType {
    
    private let repoName: String
    private let useCase: SearchUseCaseType
    
    init(repoName: String, useCase: SearchUseCaseType) {
        self.repoName = repoName
        self.useCase = useCase
    }
    
    func transform(input: UserRepoDetailsViewModelInput) -> UserRepoDetailsViewModelOutput {
        let userRepoDetails = input.appear
            .flatMap({[unowned self] _ in self.useCase.repoDetails(for: self.repoName) })
            .map({ result -> UserRepoDetailsState in
                switch result {
                case .success(let repos): return .success(self.viewModel(from: repos))
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        let loading: UserRepoDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        
        return Publishers.Merge(loading, userRepoDetails).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func viewModel(from repos: [UserReposDetailModel]) -> [RepoDetailViewModel] {
        return GithubViewModelBuilder.viewModel(from: repos, imageLoader: {[unowned self] _ in self.useCase.loadImage(for: repos.first!)})
    }
}
