//
//  GithubUserSearchFlowCoordinator.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//

import UIKit

/// The `ReposSearchFlowCoordinator` takes control over the flows on the repo search screen
class GithubUserSearchFlowCoordinator: FlowCoordinator {
    fileprivate let rootController: UINavigationController
    fileprivate let dependencyProvider: GithubUserSearchFlowCoordinatorDependencyProvider

    init(rootController: UINavigationController, dependencyProvider: GithubUserSearchFlowCoordinatorDependencyProvider) {
        self.rootController = rootController
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchController = self.dependencyProvider.githubSearchController(navigator: self)
        self.rootController.setViewControllers([searchController], animated: false)
    }

}

extension GithubUserSearchFlowCoordinator: GithubSearchNavigator {

    func showDetails(forRepo repoId: Int) {
        let controller = self.dependencyProvider.githubDetailsController(repoId)
        self.rootController.pushViewController(controller, animated: true)
    }

}
