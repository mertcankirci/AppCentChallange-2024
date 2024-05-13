//
//  SortingOptionCell.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 13.05.2024.
//

import UIKit

class SortingOptionCell: UITableViewCell {
    
    static let reuseID = "SortingOptionCell"
    var optionLabel: ACBodyLabel!
    var selectedImage: UIImageView!
    var sortingOpiton: SortingOptions!
    let padding: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(for sortingOption: SortingOptions) {
        self.sortingOpiton = sortingOption
        self.optionLabel.text = UIHelper.getStringForsortingOption(for: sortingOption)
        isSelected = sortingOption == NetworkManager.shared.sortingOption
    }
    
    func configure() {
        optionLabel = ACBodyLabel(textAlignment: .left)
        optionLabel.textColor = .label
        
        selectedImage = UIImageView(image: UIImage(systemName: isSelected ? "circle.circle.fill" : "circle.circle"))
        selectedImage.tintColor = .systemPink
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectedImage)
        addSubview(optionLabel)
        
        NSLayoutConstraint.activate([
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            optionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
            optionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            
           selectedImage.centerYAnchor.constraint(equalTo: centerYAnchor),
           selectedImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
           selectedImage.heightAnchor.constraint(equalToConstant: 30),
           selectedImage.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
