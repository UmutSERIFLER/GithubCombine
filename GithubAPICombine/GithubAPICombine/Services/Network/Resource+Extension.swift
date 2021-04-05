//
//  Resource+Extension.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

extension Resource {

    static func repos(query: String) -> Resource<Users> {
        let url = URL(string: "https://api.github.com/")!.appendingPathComponent("search/users")
        let parameters: [String : CustomStringConvertible] = [
            "q": query,
            ]
        return Resource<Users>(url: url, parameters: parameters)
    }

    static func userRepoDetails(for repoOwner: String) -> Resource<[UserReposDetailModel]> {
        let url = URL(string: "https://api.github.com/")!.appendingPathComponent("users/\(repoOwner)/repos")
        return Resource<[UserReposDetailModel]>(url: url)
    }
}
