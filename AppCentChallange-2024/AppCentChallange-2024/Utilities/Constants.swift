//
//  Constants.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 11.05.2024.
//

import UIKit

enum SFSymbols {
    static let edit = "square.and.pencil"
    static let endEdit = "pencil.slash"
    static let source = "mappin"
    static let date = "calendar"
    static let beforeSave = "bookmark"
    static let afterSave = "bookmark.fill"
    static let share = "square.and.arrow.up"
    static let author = "person.fill"
    static let delete = "minus.circle.fill"
    static let sortingOptions = "arrow.up.and.down.text.horizontal"
}

enum Images {
    static let emptyArticleImage = UIImage(named: "news-placeholder")
}

enum SortingOptions: String, CaseIterable{
    case relevancy = "relevancy"
    case popularity = "popularity"
    case publishedAt = "publishedAt"
}
