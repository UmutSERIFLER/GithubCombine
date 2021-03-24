//
//  ImageSize.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

enum ImageSize {
    case small
    case original
    var url: URL {
        switch self {
        case .small: return URL(string: "")!//ApiConstants.smallImageUrl
        case .original: return URL(string: "")!//ApiConstants.originalImageUrl
        }
    }
}
