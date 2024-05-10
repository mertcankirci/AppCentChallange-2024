//
//  NewsDetailVC.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

protocol NewsDetailDissapearDelegate: AnyObject {
    func detailVcWillDissapear()
}

class NewsDetailVC: UIViewController {
    
    var article: Article!
    var isSaved: Bool!
    var saveButton: UIBarButtonItem!
    var shareButton: UIBarButtonItem!
    var newsImageView = ACNewsImageView(frame: .zero)
    var titleLabel = ACTitleLabel(textAlignment: .left, fontSize: 18) //Might need to adjust
    var descriptionLabel = ACBodyLabel(textAlignment: .left)
    var sourceView: ACCustomLabelItemView!
    var dateView: ACCustomLabelItemView!
    var authorView: ACCustomLabelItemView!
    weak var delegate: NewsDetailDissapearDelegate?
    var safariButton: ACButton!

    let padding: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIsSaved()
        configureViewController()
        configureUIElements()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.detailVcWillDissapear()
    }
    
    func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        
        let backButton = UIBarButtonItem()
        backButton.title = "Home"
        backButton.tintColor = .systemPink
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        saveButton = UIBarButtonItem(image: UIImage(systemName: isSaved ? "bookmark.fill" : "bookmark"), style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = .systemPink
        
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        shareButton.tintColor = .systemPink
        
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    
    func configureUIElements() {
        
        let width = view.bounds.width
        let availableWidth = (width - (3 * padding)) / 3
        let height = view.bounds.height
        
        newsImageView.downloadImage(from: article.urlToImage ?? "")
        newsImageView.layer.cornerRadius = 12
        titleLabel.text = article.title
        titleLabel.numberOfLines = 3
        descriptionLabel.text = article.description
        descriptionLabel.numberOfLines = 10
        
        sourceView = ACCustomLabelItemView(symbolName: "mappin", labelText: article?.source?.name ?? "Unkown", color: .systemPink, textAlignment: .center)
        dateView = ACCustomLabelItemView(symbolName: "calendar", labelText: NetworkManager.shared.formatDate(for: article?.publishedAt ?? "Unkown"), color: .systemPink, textAlignment: .right)
        authorView = ACCustomLabelItemView(symbolName: "person.fill", labelText: article.author ?? "Unknown", color: .systemPink, textAlignment: .left)
        
        safariButton = ACButton(backgroundColor: .systemPink, title: "News Source")
        safariButton.addTarget(self, action: #selector(safariButtonTapped), for: .touchUpInside)
        
        view.addSubview(newsImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(dateView)
        view.addSubview(sourceView)
        view.addSubview(authorView)
        view.addSubview(safariButton)
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            newsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            newsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            newsImageView.heightAnchor.constraint(equalToConstant: (width - (2 * padding)) * 0.65),
            
            authorView.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
            authorView.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            authorView.widthAnchor.constraint(lessThanOrEqualToConstant: availableWidth),
            
            sourceView.centerYAnchor.constraint(equalTo: authorView.centerYAnchor),
            sourceView.leadingAnchor.constraint(equalTo: authorView.trailingAnchor, constant: padding / 2),
            sourceView.widthAnchor.constraint(lessThanOrEqualToConstant: availableWidth),
            
            dateView.centerYAnchor.constraint(equalTo: authorView.centerYAnchor),
            dateView.leadingAnchor.constraint(equalTo: sourceView.trailingAnchor, constant: padding / 2),
            dateView.widthAnchor.constraint(lessThanOrEqualToConstant: availableWidth),
            
            titleLabel.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: padding / 2),
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: -(2 * padding)),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: height * 0.35),
            
            safariButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding / 2),
            safariButton.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: 2 * padding),
            safariButton.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: -2 * padding),
            safariButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func saveButtonTapped() {
        showLoadingView()
        isSaved.toggle()
        if isSaved {
            PersistanceManager.updateWith(article: article, actionType: .add) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    self.presentACAlertOnMainThread(title: "Success !", message: "You've successfully saved this article", buttonTitle: "Ok")
                    return
                }
                self.presentACAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        } else {
            PersistanceManager.updateWith(article: article, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    self.presentACAlertOnMainThread(title: "Success !", message: "You've successfully unsaved this article", buttonTitle: "Ok")
                    return
                }
                self.presentACAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        self.dismissLoadingView()
        saveButton.image = UIImage(systemName: isSaved ? "bookmark.fill" : "bookmark")
    }
    
    private func checkIsSaved() {
        PersistanceManager.isSaved(article: article) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.isSaved = success
            case .failure(let error):
                self.presentACAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    @objc func shareButtonTapped() {
        let shareText = """
        Look at this article !
        \(String(describing: titleLabel.text))
        """
        let shareImage = newsImageView.image
        let shareUrl = String(describing: article.url ?? "CorruptedURL")
        let shareViewController = UIActivityViewController(activityItems: [shareText, shareImage ?? UIImage(named: "news-placeholder")!, shareUrl], applicationActivities: [])
        shareViewController.editButtonItem.tintColor = .systemPink
        present(shareViewController, animated: true)
    }
    
    @objc func safariButtonTapped() {
        guard let urlString = article.url else {
            presentACAlertOnMainThread(title: "Error", message: "This news source doesnt exist", buttonTitle: "Ok")
            return
        }
        guard let url = URL(string: urlString) else { presentACAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return
            }
        presentSafariVC(with: url)
    }
}
