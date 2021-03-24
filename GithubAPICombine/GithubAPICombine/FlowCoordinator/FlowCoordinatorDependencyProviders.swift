//
//  FlowCoordinatorDependencyProviders.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//

import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: class {
    /// Creates UIViewController
    func rootViewController() -> UINavigationController
}

protocol GithubUserSearchFlowCoordinatorDependencyProvider: class {
    /// Creates UIViewController to search for repo
    func githubSearchController(navigator: GithubSearchNavigator) -> UIViewController

    // Creates UIViewController to show the details of the repo with specified identifier
    func githubDetailsController(_ repoID: Int) -> UIViewController
}
