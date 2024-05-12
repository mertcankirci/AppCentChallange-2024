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
    
    func presentEmptyStateLottieAnimation(with message: String, in view: UIView, screenType: EmptyStateScreen) {
        if let _ = emptyLottieAnimationView {
            emptyLottieAnimationView?.removeFromSuperview()
            emptyLottieAnimationView = nil
        }
        emptyLottieAnimationView = ACLottieEmptyStateView(message: message, for: screenType)
        emptyLottieAnimationView!.frame = view.bounds
        view.addSubview(emptyLottieAnimationView!)
    }
    
    func dismissEmptyStateLottieAnimation() {
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
        safariVC.navigationItem.backButtonTitle = "Back"
        safariVC.title = "News Source"
        navigationController?.pushViewController(safariVC, animated: true)
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .black
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.95 }
        
        let activityIndicatior = UIActivityIndicatorView(style: .large)
        activityIndicatior.color = .systemPink
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
    
    func showLottiePersistanceAnimation(for type: PersistanceActionType) {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black.withAlphaComponent(0.8)
        containerView.alpha = 0
        
        let animationView = LottieAnimationView(name: type == .add ? "lottie-saved" : "lottie-unsaved")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.5
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(animationView)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            animationView.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        UIView.animate(withDuration: 0.2) {
            containerView.alpha = 1
        }
        
        animationView.play { completed in
            if completed {
                UIView.animate(withDuration: 0.3) {
                    containerView.alpha = 0
                }
                containerView.removeFromSuperview()
            }
        }
    }
}



