//
//  RepoDetailViewModel.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 05/04/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

struct RepoDetailViewModel {
    
    let id: Int
    let fullName: String
    let avatarURL: AnyPublisher<UIImage?, Never>

    init(id: Int, fullName: String, avatarURL: AnyPublisher<UIImage?, Never>) {
        self.id = id
        self.fullName = fullName
        self.avatarURL = avatarURL
    }
}

extension RepoDetailViewModel: Hashable {
    static func == (lhs: RepoDetailViewModel, rhs: RepoDetailViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
