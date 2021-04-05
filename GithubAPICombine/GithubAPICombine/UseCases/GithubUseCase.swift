//
//  GithubUseCase.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//

import Foundation
import Combine
import UIKit.UIImage

protocol SearchUseCaseType {

    /// Runs users search with a query string
    func searchUsers(with name: String) -> AnyPublisher<Result<[User], Error>, Never>

    /// Fetches details for repo with specified id
    func repoDetails(for name: String) -> AnyPublisher<Result<[UserReposDetailModel], Error>, Never>

    // Loads image for the given repo
    func loadImage(for user: User) -> AnyPublisher<UIImage?, Never>
    
    // Loads image for the given repo detail
    func loadImage(for repoDetail: UserReposDetailModel) -> AnyPublisher<UIImage?, Never>
}

final class GithubUseCase: SearchUseCaseType {
   
    private let networkService: NetworkServiceType
    private let imageLoaderService: ImageLoaderServiceType

    init(networkService: NetworkServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    func searchUsers(with name: String) -> AnyPublisher<Result<[User], Error>, Never> {
        return networkService
            .load(Resource<Users>.repos(query: name))
            .map({ (result: Result<Users, NetworkError>) -> Result<[User], Error> in
                switch result {
                case .success(let repos): return .success(repos.items)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func repoDetails(for userName: String) -> AnyPublisher<Result<[UserReposDetailModel], Error>, Never> {
        return networkService
            .load(Resource<[UserReposDetailModel]>.userRepoDetails(for: userName))
            .map({ (result: Result<[UserReposDetailModel], NetworkError>) -> Result<[UserReposDetailModel], Error> in
                switch result {
                case .success(let repos): return .success(repos)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func loadImage(for user: User) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(user.avatar_url) }
        .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
            return self.imageLoaderService.loadImage(from: URL(string: user.avatar_url)!)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }
    
    func loadImage(for repoDetail: UserReposDetailModel) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(repoDetail.owner.avatar_url) }
        .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
            return self.imageLoaderService.loadImage(from: URL(string: repoDetail.owner.avatar_url)!)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }

}
