//
//  ApplicationFlowCoordinator.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit

/// The application flow coordinator. Takes responsibility about coordinating view controllers and driving the flow
class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider & GithubUserSearchFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {

        let searchNavigationController = dependencyProvider.rootViewController()
        self.window.rootViewController = searchNavigationController

        let searchFlowCoordinator = GithubUserSearchFlowCoordinator(rootController: searchNavigationController, dependencyProvider: self.dependencyProvider)
        searchFlowCoordinator.start()

        self.childCoordinators = [searchFlowCoordinator]
    }

}
