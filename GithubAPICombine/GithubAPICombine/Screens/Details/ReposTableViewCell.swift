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
        self.addSubview(repoName)
        NSLayoutConstraint.activate([
            self.repoName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.repoName.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.repoName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.repoName.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    func bind(to viewModel: RepoDetailViewModel) {
        updateUIComponents()
        repoName.text = viewModel.fullName.components(separatedBy: "/").last
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.repoName.text = ""
    }
    
}
