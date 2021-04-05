//
//  ReposTableViewCell.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 05/04/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

class ReposTableViewCell: UITableViewCell, NibProvidable, ReusableView {
    
    private var cancellable: AnyCancellable?
    
    fileprivate lazy var repoImage : UIImageView = {
        let imageView = UIImageView(frame: CGRect.init(origin: .zero, size: CGSize(width: 50, height: 50)))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var repoName : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateUIComponents() {
        self.addSubview(repoImage)
        self.addSubview(repoName)
        NSLayoutConstraint.activate([
            self.repoImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.repoImage.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.repoImage.widthAnchor.constraint(equalToConstant: 100),
            self.repoImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.repoName.leftAnchor.constraint(equalTo: self.repoImage.rightAnchor),
            self.repoName.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.repoName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.repoName.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    func bind(to viewModel: RepoDetailViewModel) {
        updateUIComponents()
        cancelImageLoading()
        repoName.text = viewModel.fullName
        cancellable = viewModel.avatarURL.sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        cancelImageLoading()
        UIView.transition(with: self.repoImage,
        duration: 0.3,
        options: [.curveEaseOut, .transitionCrossDissolve],
        animations: {
            self.repoImage.image = image
        })
    }

    private func cancelImageLoading() {
        repoImage.image = nil
        cancellable?.cancel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }
    
}
