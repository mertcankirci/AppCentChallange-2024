//
//  UIViewController+Ext.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit
import SafariServices
import Lottie

fileprivate var containerView: UIView!
fileprivate var emptyLottieAnimationView: ACLottieEmptyStateView?

extension UIViewController {
    
    func presentACAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = ACAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentLottieAnimation(with message: String, in view: UIView, screenType: EmptyStateScreen) {
        if let _ = emptyLottieAnimationView {
            emptyLottieAnimationView?.removeFromSuperview()
            emptyLottieAnimationView = nil
        }
        emptyLottieAnimationView = ACLottieEmptyStateView(message: message, for: screenType)
        emptyLottieAnimationView!.frame = view.bounds
        view.addSubview(emptyLottieAnimationView!)
    }
    
    func dismissLottieAnimation() {
        if emptyLottieAnimationView != nil {
            DispatchQueue.main.async {
                emptyLottieAnimationView?.removeFromSuperview()
                emptyLottieAnimationView = nil
            }
        }
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemPink
        present(safariVC, animated: true)
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicatior = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicatior)
        
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatior.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicatior.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showSavedAnimation() {
        let label = UILabel()
        label.text = "Saved!"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        containerView.center = view.center
        containerView.backgroundColor = .systemGreen
        containerView.layer.cornerRadius = 10
        containerView.alpha = 0
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        containerView.addSubview(label)
        view.addSubview(containerView)
        
        UIView.animate(withDuration: 0.5, animations: {
            containerView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                containerView.alpha = 0
            }, completion: { (_) in
                containerView.removeFromSuperview()
            })
        }
    }
    
    func showUnsavedAnimation() {
        let label = UILabel()
        label.text = "Unsaved!"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        containerView.center = view.center
        containerView.backgroundColor = .systemPink
        containerView.layer.cornerRadius = 10
        containerView.alpha = 0
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        containerView.addSubview(label)
        view.addSubview(containerView)
        
        UIView.animate(withDuration: 0.5, animations: {
            containerView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                containerView.alpha = 0
            }, completion: { _ in
                containerView.removeFromSuperview()
            })
        }
    }
}



