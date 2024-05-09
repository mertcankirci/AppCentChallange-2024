//
//  NewsResponse.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import Foundation

struct NewsResponse: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}
