//
//  AlertViewModel.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct AlertViewModel {
    let title: String
    let description: String?
    let image: UIImage

    static var noResults: AlertViewModel {
        let title = NSLocalizedString("No repos found!", comment: "No repos found!")
        let description = NSLocalizedString("Try searching again...", comment: "Try searching again...")
        let image = UIImage(named: "search") ?? UIImage()
        return AlertViewModel(title: title, description: description, image: image)
    }

    static var startSearch: AlertViewModel {
        let title = NSLocalizedString("Search for a repo...", comment: "Search for a repo...")
        let image = UIImage(named: "search") ?? UIImage()
        return AlertViewModel(title: title, description: "", image: image)
    }

    static var dataLoadingError: AlertViewModel {
        let title = NSLocalizedString("Can't load search results!", comment: "Can't load search results!")
        let description = NSLocalizedString("Something went wrong. Try searching again...", comment: "Something went wrong. Try searching again...")
        let image = UIImage(named: "error") ?? UIImage()
        return AlertViewModel(title: title, description: description, image: image)
    }
}
