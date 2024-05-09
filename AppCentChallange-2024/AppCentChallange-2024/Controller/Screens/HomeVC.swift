//
//  HomeVC.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var query: String? = nil
    var news: [Article] = []
    var page: Int = 1
    var hasMoreNews: Bool = false
    var isSearching: Bool = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Article>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        configureDataSource()
        configureSearchController()
        getNews(query: "Bitocin")
    }
    
    func getNews(query: String) {
        showLoadingView()
        NetworkManager.shared.getNews(for: query, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let success):
                guard let articles = success.articles else { return }
                if articles.count <= 0 {
                    hasMoreNews = false
                    //MARK: Empty state view tekrar bak
                }
                
                self.news.append(contentsOf: articles)
                
                if self.news.isEmpty {
                    let message = "Please search a keyword."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                self.updateData(on: articles)
                
            case .failure(let failure):
                self.presentACAlertOnMainThread(title: "Something went wrong", message: failure.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createNewsFlowLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
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
        print(snapshot)
        DispatchQueue.main.async{ self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search..."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.leftView?.tintColor = .systemPink
        navigationItem.searchController = searchController
    }
}

extension HomeVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offSetY > contentHeight - height {
            guard hasMoreNews else { return }
            guard let query = query else { return }
            page += 1
            getNews(query: query)
        }
    }
}

extension HomeVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { news.removeAll(); return }
        print(query)
        isSearching = true
        //        getNews(query: query)
    }
    
}
