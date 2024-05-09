//
//  NewsCell.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    static let reuseId = "NewsCell"
    var article: Article? = nil
    var newsImageView = ACNewsImageView(frame: .zero)
    var titleLabel = ACTitleLabel(textAlignment: .left, fontSize: 14) //Might need to adjust
    var descriptionLabel = ACSecondaryBodyLabel(textAlignment: .left)
    var sourceView: ACCustomLabelItemView!
    var dateView: ACCustomLabelItemView!
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(article: Article) {
        self.article = article
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.description
        newsImageView.downloadImage(from: article.urlToImage ?? "")
        sourceView.label.text = article.source?.name ?? "Unknown"
        dateView.label.text = formatDate(for: article.publishedAt ?? "Unkown")
    }
    
    func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        let width = bounds.width
        sourceView = ACCustomLabelItemView(symbolName: "mappin", labelText: article?.source?.name ?? "Unkown", color: .systemPink, textAlignment: .left)
        dateView = ACCustomLabelItemView(symbolName: "calendar", labelText: formatDate(for: article?.publishedAt ?? "Unkown"), color: .systemPink, textAlignment: .left)
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 4
        
        addSubview(newsImageView)
        addSubview(sourceView)
        addSubview(dateView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: width),
            newsImageView.heightAnchor.constraint(equalToConstant: width * 0.45),
            
            sourceView.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
            sourceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            sourceView.widthAnchor.constraint(equalToConstant: 90),
            
            dateView.topAnchor.constraint(equalTo: sourceView.bottomAnchor, constant: padding),
            dateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            dateView.widthAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: sourceView.leadingAnchor, constant: -(3 * padding)),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: padding / 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    private func formatDate(for date: String) -> String {
        guard let formattedDate = date.convertToDate() else { return ""}
        return formattedDate.convertToMonthYearDayFormat()
    }
}
