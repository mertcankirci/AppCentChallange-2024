//
//  NewsDetailVC.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class NewsDetailVC: UIViewController {
    
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        
        let backButton = UIBarButtonItem()
        backButton.title = "Home"
        backButton.tintColor = .systemPink
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
}
