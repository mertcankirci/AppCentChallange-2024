//
//  NetworkManager.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/everything?q="
    //MARK: I've also generated a second apiKey in case any issues arise.
    private let apiKey = "df0425863c604827a5f5ef4eef003db2"
    private let apiKey2 = "413e3cb8905240bfa14bc5de86c216ca"
    var sortingOption: SortingOptions = .publishedAt
    let cache = NSCache<NSString, UIImage>()
    
    private init () { }
    
    func getNews(for query: String, page: Int, completed: @escaping(Result<NewsResponse, ACError>) -> Void) {
        let endPoint = baseURL + "\(query)&page=\(page)&sortBy=\(sortingOption.rawValue)&apiKey=\(apiKey)"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidQuery))
            return
        }
        
    //MARK: I'm aware that Alamofire has its own Error class, but I want to show custom errors that I've created to the user. That's why I followed this approach.
        AF.request(url, method: .get).validate().responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let news):
                completed(.success(news))
            case .failure(_):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 400...499:
                        if statusCode == 429 {
                            completed(.failure(.tooManyRequests))
                        } else {
                            completed(.failure(.invalidQuery))
                        }
                    case 500...599:
                        completed(.failure(.unableToComplete))
                    default:
                        completed(.failure(.invalidData))
                    }
                } else {
                    completed(.failure(.invalidResponse))
                }
            }
        }
    }
}
