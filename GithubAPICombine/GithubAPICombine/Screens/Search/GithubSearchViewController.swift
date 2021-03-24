//
//  GithubSearchViewController.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 25/02/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import UIKit
import Combine

class GithubSearchViewController : UIViewController {

    private var cancellables: [AnyCancellable] = []
    private let viewModel: GithubSearchViewModelType
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()

    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet private var tableview: UITableView!
    private lazy var alertViewController = AlertViewController(nibName: nil, bundle: nil)
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    private lazy var dataSource = makeDataSource()

    init(viewModel: GithubSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    private func configureUI() {
        definesPresentationContext = true
        title = NSLocalizedString("Repos", comment: "Top Repo")
        tableview.tableFooterView = UIView()
        tableview.registerNib(cellClass: RepoTableViewCell.self)
        tableview.dataSource = dataSource

        navigationItem.searchController = self.searchController
        searchController.isActive = true

        add(alertViewController)
        alertViewController.showStartSearch()
    }

    private func bind(to viewModel: GithubSearchViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = GithubSearchViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: GithubSearchState) {
        switch state {
        case .idle:
            alertViewController.view.isHidden = false
            alertViewController.showStartSearch()
            loadingView.isHidden = true
            update(with: [], animate: true)
        case .loading:
            alertViewController.view.isHidden = true
            loadingView.isHidden = false
            update(with: [], animate: true)
        case .noResults:
            alertViewController.view.isHidden = false
            alertViewController.showNoResults()
            loadingView.isHidden = true
            update(with: [], animate: true)
        case .failure:
            alertViewController.view.isHidden = false
            alertViewController.showDataLoadingError()
            loadingView.isHidden = true
            update(with: [], animate: true)
        case .success(let repos):
            alertViewController.view.isHidden = true
            loadingView.isHidden = true
            update(with: repos, animate: true)
        }
    }
}

fileprivate extension GithubSearchViewController {
    enum Section: CaseIterable {
        case repos
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, GithubViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableview,
            cellProvider: {  tableView, indexPath, repoViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: RepoTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(RepoTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: repoViewModel)
                return cell
            }
        )
    }

    func update(with repos: [GithubViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, GithubViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(repos, toSection: .repos)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension GithubSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}

extension GithubSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}

