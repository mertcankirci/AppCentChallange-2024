//
//  HomeVC.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: Empty state view'lar ust uste biniyor buna bir didntSearchView yaz.
    
    enum Section {
        case main
    }
    
    var query: String? = nil
    var lastQuery: String? = nil
    var news: [Article] = []
    var page: Int = 1
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Article>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if news.isEmpty {
//            showEmptyStateView(with: "Please search a keyword for news", in: self.view)
//        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        deleteButton.tintColor = .systemPink
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createNewsFlowLayout(in: view))
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseId)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, news) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseId, for: indexPath) as! NewsCell
            cell.set(article: news)
            return cell
        })
    }
    
    func updateData(on news: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(news)
        DispatchQueue.main.async{ self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search..."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.leftView?.tintColor = .systemPink
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func getNews(query: String) {
        showLoadingView()
        NetworkManager.shared.getNews(for: query, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                self.dismissLoadingView()
                
                guard let articles = success.articles else { return }
                if articles.count <= 0 {
                    presentACAlertOnMainThread(title: "Run out of news", message: "No news", buttonTitle: "Ok")
                    return
                }
                
                self.news.append(contentsOf: articles)
                
                if self.news.isEmpty {
                    let message = "Please search a keyword."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                self.updateData(on: news)
                
            case .failure(let failure):
                self.dismissLoadingView()
                self.presentACAlertOnMainThread(title: "Something went wrong", message: failure.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        if self.news.isEmpty {
            presentACAlertOnMainThread(title: "You don't have any news yet", message: "Please search", buttonTitle: "Ok")
            collectionView.scrollsToTop = true
        } else {
            self.news.removeAll()
            updateData(on: self.news)
            collectionView.scrollsToTop = true
        }
    }

}

extension HomeVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offSetY > contentHeight - height {
            guard let query = query else { return }
            if lastQuery != query {
                page += 1
            }
            getNews(query: query)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = self.news[indexPath.item]
        
        let destinationVC = NewsDetailVC()
        destinationVC.article = article
        destinationVC.title = "Article Detail"
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension HomeVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) { }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        if lastQuery != query {
            page = 1
            news.removeAll();
            collectionView.scrollsToTop = true
        }
        self.query = searchBar.text
        getNews(query: query)
        searchBar.resignFirstResponder()
        navigationItem.searchController?.isActive = false
        
    }
}

