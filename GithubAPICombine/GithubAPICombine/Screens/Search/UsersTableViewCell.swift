//
//  UsersTableViewCell.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 26/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

class UsersTableViewCell: UITableViewCell, NibProvidable, ReusableView {
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var poster: UIImageView!
    private var cancellable: AnyCancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }

    func bind(to viewModel: GithubViewModel) {
        cancelImageLoading()
        title.text = viewModel.fullName
        subtitle.text = viewModel.itemDescription
        rating.text = "Rating: \(viewModel.forksCount)"
        cancellable = viewModel.avatarURL.sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        cancelImageLoading()
        UIView.transition(with: self.poster,
        duration: 0.3,
        options: [.curveEaseOut, .transitionCrossDissolve],
        animations: {
            self.poster.image = image
        })
    }

    private func cancelImageLoading() {
        poster.image = nil
        cancellable?.cancel()
    }
    
}
