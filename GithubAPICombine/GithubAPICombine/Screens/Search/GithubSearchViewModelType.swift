//
//  GithubSearchViewModelType.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Combine

struct GithubSearchViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
    /// called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

enum GithubSearchState {
    case idle
    case loading
    case success([GithubViewModel])
    case noResults
    case failure(Error)
}

extension GithubSearchState: Equatable {
    static func == (lhs: GithubSearchState, rhs: GithubSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsRepos), .success(let rhsRepos)): return lhsRepos == rhsRepos
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias GithubSearchViewModelOuput = AnyPublisher<GithubSearchState, Never>

protocol GithubSearchViewModelType {
    func transform(input: GithubSearchViewModelInput) -> GithubSearchViewModelOuput
}
