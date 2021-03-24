//
//  GithubSearchNavigator.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

protocol GithubSearchNavigator: AutoMockable, AnyObject {
    /// Presents the repos details screen
    func showDetails(forRepo repoId: Int)
}
