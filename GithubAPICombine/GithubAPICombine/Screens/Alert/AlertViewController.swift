//
//  AlertViewController.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showStartSearch() {
        render(viewModel: AlertViewModel.startSearch)
    }

    func showNoResults() {
        render(viewModel: AlertViewModel.noResults)
    }

    func showDataLoadingError() {
        render(viewModel: AlertViewModel.dataLoadingError)
    }

    fileprivate func render(viewModel: AlertViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.image = viewModel.image
    }
}
