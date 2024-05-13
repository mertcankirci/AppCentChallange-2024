//
//  ACCustomLabelItemView.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 9.05.2024.
//

import UIKit
//MARK: A custom view for displaying an icon and text within a cell.
class ACCustomLabelItemView: UIView {
    
    var imageView: UIImageView
    var label: ACSecondaryBodyLabel
    
    init(symbolName: String, labelText: String, color: UIColor, textAlignment: NSTextAlignment) {
        
        self.imageView = UIImageView(image: UIImage(systemName: symbolName))
        self.label = ACSecondaryBodyLabel(textAlignment: textAlignment)
        self.label.text = labelText
        self.imageView.tintColor = color
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        addSubview(imageView)
        addSubview(label)
        
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: imageView.heightAnchor),
            heightAnchor.constraint(equalTo: label.heightAnchor),
        ])
    }
}

