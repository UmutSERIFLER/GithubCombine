//
//  Resource+Extension.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

extension Resource {

    static func repos(query: String) -> Resource<Repos> {
        let url = URL(string: "https://api.github.com/")!.appendingPathComponent("search/repositories")
        let parameters: [String : CustomStringConvertible] = [
            "q": query,
            ]
        return Resource<Repos>(url: url, parameters: parameters)
    }

//    static func details(repoId: Int) -> Resource<Repo> {
//        let url = URL(string: "https://api.github.com/")!.appendingPathComponent("/repositories/\(repoId)")
//        let parameters: [String : CustomStringConvertible] = [
//            "api_key": "",
//            "language": ""//Locale.preferredLanguages[0]
//            ]
//        return Resource<Repo>(url: url, parameters: parameters)
//    }
}
