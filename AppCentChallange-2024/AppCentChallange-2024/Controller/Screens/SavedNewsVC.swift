//
//  SavedNewsVC.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class SavedNewsVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var articles: [Article]? = nil
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Article>!
    var deleteButton: UIBarButtonItem!
    var article: Article? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        configureVC()
        retrieveSaved()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        deleteButton.image = UIImage(systemName: SFSymbols.edit)
        retrieveSaved()
        guard let collectionView = collectionView else { return }
        collectionView.isEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        deleteButton = UIBarButtonItem(image: UIImage(systemName: SFSymbols.edit), style: .plain, target: self, action: #selector(deleteButtonTapped))
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
            cell.minusButtonDelegate = self
            cell.minusButton.isHidden = true
            return cell
        })
    }
    
    func updateData(on news: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(news)
        DispatchQueue.main.async{ self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func retrieveSaved() {
        PersistanceManager.retrieveSaved { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                self.articles = success
                guard let articles = self.articles else { return }
                UIHelper.emptyStateViewHelper(in: self, articles: articles, screen: .saved)
            case .failure(let error):
                self.presentACAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        updateData(on: self.articles ?? [])
    }
    
    @objc func deleteButtonTapped() {
        collectionView.isEditing.toggle()
        for cell in collectionView.visibleCells {
            if let newsCell = cell as? NewsCell {
                newsCell.minusButton.isHidden = !collectionView.isEditing
            }
        }
        deleteButton.image = UIImage(systemName: collectionView.isEditing ? SFSymbols.endEdit : SFSymbols.edit)
    }
}

extension SavedNewsVC: UICollectionViewDelegate { 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let articles = articles else { return }
        let article = articles[indexPath.item]
        self.article = article
        
        let destinationVC = NewsDetailVC()
        destinationVC.article = article
        destinationVC.title = "Article Detail"
        destinationVC.delegate = self
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension SavedNewsVC: NewsCellDelegate {
    func minusButtonTapped(for article: Article) {
            PersistanceManager.updateWith(article: article, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
        //MARK: I'm checking if there's only one element in the articles array because if it's the last one, It cancels animation and shows the empty state view. To prevent this, I'm using the count of the array to determine whether to show the animation to the user using the asyncAfter method.
                    
                    let isLast = self.articles?.count == 1
                    
                    self.articles?.removeAll(where: { $0.title == article.title })
                    updateData(on: self.articles ?? [])
                    
                    guard let articles = self.articles else { return }

                    if isLast {
                        //MARK: For changing edit button image and adjusting collection view because news are empty.
                        
                        deleteButton.image = UIImage(systemName: SFSymbols.edit)
                        collectionView.isEditing.toggle()
                        
                        showLottiePersistanceAnimation(for: .remove)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            UIHelper.emptyStateViewHelper(in: self, articles: articles, screen: .saved) //Here waiting for unsave animation to finish.
                        }
                    } else {
                        showLottiePersistanceAnimation(for: .remove)
                        UIHelper.emptyStateViewHelper(in: self, articles: articles, screen: .saved)
                    }
                    return
                }
                self.presentACAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
    }
}

extension SavedNewsVC: NewsDetailDissapearDelegate {
    func detailVcWillDissapear() {
        retrieveSaved()
    }
}
