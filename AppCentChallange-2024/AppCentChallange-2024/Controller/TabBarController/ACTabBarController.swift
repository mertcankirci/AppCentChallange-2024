//
//  ACTabBarController.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class ACTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemPink
        viewControllers = [createHomeVC(), createSavedNewsVC()]
    }
    
    func createHomeVC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.title = "Appcent News App"
        let tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        tabBarItem.tag = 0
        homeVC.tabBarItem = tabBarItem
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createSavedNewsVC() -> UINavigationController {
        let savedNewsVC = SavedNewsVC()
        savedNewsVC.title = "Saved News"
        let tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        tabBarItem.tag = 1
        savedNewsVC.tabBarItem = tabBarItem
        
        return UINavigationController(rootViewController: savedNewsVC)
    }
    
    func createTabBar() -> UITabBarController {
        let tabbar = UITabBarController()
        
        
        return tabbar
    }

}
