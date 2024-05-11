//
//  ACLottieEmptyStateView.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 11.05.2024.
//

import UIKit
import Lottie

class ACLottieEmptyStateView: UIView {
    
    let messageLabel = ACTitleLabel(textAlignment: .center, fontSize: 22)
    var lottieView = LottieAnimationView(name: "lottie-empty-home")
    var screenType: EmptyStateScreen?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String, for type: EmptyStateScreen) {
        super.init(frame: .zero)
        messageLabel.text = message
        messageLabel.tintColor = .secondaryLabel
        screenType = type
        configure()
    }
    
    func configure() {
        
        backgroundColor = .secondarySystemBackground
        
        if screenType == .saved {
            lottieView = LottieAnimationView(name: "lottie-empty-saved")
        }
        
        addSubview(messageLabel)
        addSubview(lottieView)
        
        messageLabel.numberOfLines = 4
        messageLabel.textColor = .secondaryLabel
        
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .autoReverse
        lottieView.animationSpeed = 0.5
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 100),
            
            lottieView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 50),
            lottieView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lottieView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            lottieView.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
        
        lottieView.play()
    }
    
    
    
}
