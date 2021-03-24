//
//  ApplicationComponentsFactory.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit

/// The ApplicationComponentsFactory takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    fileprivate lazy var useCase: SeaarchUseCaseType = GithubUseCase(networkService: servicesProvider.network, imageLoaderService: servicesProvider.imageLoader)

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {

    func rootViewController() -> UINavigationController {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.tintColor = .label
        return rootViewController
    }
}

extension ApplicationComponentsFactory: GithubUserSearchFlowCoordinatorDependencyProvider {
   
    func githubSearchController(navigator: GithubSearchNavigator) -> UIViewController {
        let viewModel = GithubSearchViewModel(useCase: useCase, navigator: navigator)
        return GithubSearchViewController(viewModel: viewModel)
    }

    func githubDetailsController(_ repoId: Int) -> UIViewController {
//        let viewModel = GithubSearchViewModel(movieId: movieId, useCase: useCase)
//        return MovieDetailsViewController(viewModel: viewModel)
        return UIViewController()
    }
}
