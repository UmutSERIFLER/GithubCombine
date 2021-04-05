//
//  GithubViewModelBuilder.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 26/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

struct GithubViewModelBuilder {
    static func viewModel(from user: User, imageLoader: (User) -> AnyPublisher<UIImage?, Never>) -> GithubViewModel {
        return GithubViewModel(id: user.id, fullName: user.login, itemDescription: user.node_id, forksCount: Int(user.score), avatarURL: imageLoader(user), score: String(format: "%.2f", user.score))
    }
    
    static func viewModel(from reposDetail: [UserReposDetailModel], imageLoader: (UserReposDetailModel) -> AnyPublisher<UIImage?, Never>) -> [RepoDetailViewModel] {
        return reposDetail.map({ RepoDetailViewModel(id: $0.id, fullName: $0.full_name, avatarURL: imageLoader($0)) })
    }
}
