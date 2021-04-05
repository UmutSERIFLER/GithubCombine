//
//  Users.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

struct Users: Decodable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [User]
}
