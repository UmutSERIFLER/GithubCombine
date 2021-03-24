//
//  GithubViewModel.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

struct GithubViewModel {
    
    let id: Int
    let fullName: String
    let itemDescription: String
    let forksCount: Int
    let avatarURL: AnyPublisher<UIImage?, Never>
    let score: String

    init(id: Int, fullName: String, itemDescription: String, forksCount: Int, avatarURL: AnyPublisher<UIImage?, Never>, score: String) {
        self.id = id
        self.fullName = fullName
        self.itemDescription = itemDescription
        self.forksCount = forksCount
        self.avatarURL = avatarURL
        self.score = score
    }
}

extension GithubViewModel: Hashable {
    static func == (lhs: GithubViewModel, rhs: GithubViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}




