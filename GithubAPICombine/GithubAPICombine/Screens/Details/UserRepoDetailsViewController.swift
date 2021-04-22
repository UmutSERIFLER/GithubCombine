//
//  UserRepoDetailsViewController.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 27/03/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

class UserRepoDetailsViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    private let viewModel: UserRepoDetailsViewModelType
    private var cancellables: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<String, Never>()
    @IBOutlet weak var reposTableView: UITableView!
    
    private lazy var dataSource = makeDataSource()
    
    init(viewModel: UserRepoDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reposTableView.tableFooterView = UIView()
        reposTableView.register(ReposTableViewCell.self, forCellReuseIdentifier: ReposTableViewCell.nibName)
        reposTableView.dataSource = dataSource
        bind(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appear.send(())
    }

    private func bind(to viewModel: UserRepoDetailsViewModelType) {
        let input = UserRepoDetailsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                                  selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: UserRepoDetailsState) {
        switch state {
        case .loading, .failure:
            print("\(state)")
        case .success(let userReposDetail):
            showRepos(userReposDetail)
        }
    }

    private func showRepos(_ reposDetails: [RepoDetailViewModel]) {
        let respositoryOwnerName = reposDetails.first?.fullName.components(separatedBy: "/").first
        title = NSLocalizedString(respositoryOwnerName ?? "", comment: "UnknownRepoOwner")
        detailTitle.text = ("Repository Owner : \(respositoryOwnerName ?? "")")
        reposDetails.first?.avatarURL
            .assign(to: \UIImageView.image, on: self.detailImage)
            .store(in: &cancellables)
        update(with: reposDetails, animate: true)
    }
}

fileprivate extension UserRepoDetailsViewController {
    enum Section: CaseIterable {
        case repos
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, RepoDetailViewModel> {
        return UITableViewDiffableDataSource(
            tableView: reposTableView,
            cellProvider: {  tableView, indexPath, repoViewModel in
                print(indexPath.row)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReposTableViewCell.nibName, for: indexPath) as? ReposTableViewCell else {
                    assertionFailure("Failed to dequeue \(ReposTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: repoViewModel)
                return cell
            }
        )
    }
    
    func update(with values: [RepoDetailViewModel], animate: Bool) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, RepoDetailViewModel>()
            snapshot.appendSections([.repos])
            snapshot.appendItems(values, toSection: .repos)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension UserRepoDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row].fullName)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
