//
//  GithubUseCase.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//

import Foundation
import Combine
import UIKit.UIImage

protocol SeaarchUseCaseType {

    /// Runs repos search with a query string
    func searchRepos(with name: String) -> AnyPublisher<Result<[Repo], Error>, Never>

//    /// Fetches details for repo with specified id
//    func repoDetails(with id: Int) -> AnyPublisher<Result<Repo, Error>, Never>

    // Loads image for the given repo
    func loadImage(for repo: Repo) -> AnyPublisher<UIImage?, Never>
}

final class GithubUseCase: SeaarchUseCaseType {

    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageLoaderServiceType

    init(networkService: NetworkServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    func searchRepos(with name: String) -> AnyPublisher<Result<[Repo], Error>, Never> {
        return networkService
            .load(Resource<Repos>.repos(query: name))
            .map({ (result: Result<Repos, NetworkError>) -> Result<[Repo], Error> in
                switch result {
                case .success(let repos): return .success(repos.items)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

//    func repoDetails(with id: Int) -> AnyPublisher<Result<Repo, Error>, Never> {
//        return networkService
//            .load(Resource<Repo>.details(repoId: id))
//            .map({ (result: Result<Repo, NetworkError>) -> Result<Repo, Error> in
//                switch result {
//                case .success(let repo): return .success(repo)
//                case .failure(let error): return .failure(error)
//                }
//            })
//            .subscribe(on: Scheduler.backgroundWorkScheduler)
//            .receive(on: Scheduler.mainScheduler)
//            .eraseToAnyPublisher()
//    }

    func loadImage(for repo: Repo) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(repo.owner.avatarURL) }
        .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
            return self.imageLoaderService.loadImage(from: URL(string: repo.owner.avatarURL)!)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }

}
