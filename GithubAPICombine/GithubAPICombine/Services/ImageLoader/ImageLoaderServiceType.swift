//
//  ImageLoaderServiceType.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceType: AnyObject, AutoMockable {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
