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
    static func viewModel(from repo: Repo, imageLoader: (Repo) -> AnyPublisher<UIImage?, Never>) -> GithubViewModel {
        return GithubViewModel(id: repo.id, fullName: repo.fullName, itemDescription: repo.nodeID, forksCount: repo.forksCount, avatarURL: imageLoader(repo), score: String(format: "%.2f", repo.forksCount))
    }
}
