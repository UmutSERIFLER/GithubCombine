//
//  Resource.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]?
    var request: URLRequest? {
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        guard let params = parameters else {
            return URLRequest(url: url)
        }
        
        components.queryItems = params.keys.map { key in
            URLQueryItem(name: key, value: params[key]?.description)
        }
        
        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }

    init(url: URL, parameters: [String: CustomStringConvertible]? = nil) {
        self.url = url
        self.parameters = parameters
    }
}
