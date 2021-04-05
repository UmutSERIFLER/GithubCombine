//
//  UserRepoDetailsViewModelType.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 27/03/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

// INPUT
struct UserRepoDetailsViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    let selection: AnyPublisher<String, Never>
}

// OUTPUT
enum UserRepoDetailsState {
    case loading
    case success([RepoDetailViewModel])
    case failure(Error)
}

extension UserRepoDetailsState: Equatable {
    static func == (lhs: UserRepoDetailsState, rhs: UserRepoDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsRepo), .success(let rhsRepo)): return lhsRepo.first?.id  == rhsRepo.first?.id
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias UserRepoDetailsViewModelOutput = AnyPublisher<UserRepoDetailsState, Never>

protocol UserRepoDetailsViewModelType: AnyObject {
    func transform(input: UserRepoDetailsViewModelInput) -> UserRepoDetailsViewModelOutput
}
