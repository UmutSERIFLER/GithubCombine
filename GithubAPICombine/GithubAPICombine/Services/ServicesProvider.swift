//
//  ServicesProvider.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

class ServicesProvider {
    let network: NetworkServiceType
    let imageLoader: ImageLoaderServiceType

    static func defaultProvider() -> ServicesProvider {
        let network = NetworkService()
        let imageLoader = ImageLoaderService()
        return ServicesProvider(network: network, imageLoader: imageLoader)
    }

    init(network: NetworkServiceType, imageLoader: ImageLoaderServiceType) {
        self.network = network
        self.imageLoader = imageLoader
    }
}
