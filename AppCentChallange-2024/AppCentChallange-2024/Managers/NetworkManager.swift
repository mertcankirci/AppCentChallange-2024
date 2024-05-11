//
//  NetworkManager.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/everything?q="
    private let apiKey = "df0425863c604827a5f5ef4eef003db2"
    private let apiKey2 = "413e3cb8905240bfa14bc5de86c216ca"
    let cache = NSCache<NSString, UIImage>()
    
    private init () {}
    
    
    func getNews(for query: String, page: Int, completed: @escaping(Result<NewsResponse, ACError>) -> Void) {
        let endPoint = baseURL + "\(query)&page=\(page)&apiKey=\(apiKey)"
        #if DEBUG
        print(endPoint)
        #endif
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidQuery))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let news = try decoder.decode(NewsResponse.self, from: data)
                completed(.success(news))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func formatDate(for date: String) -> String {
        guard let formattedDate = date.convertToDate() else { return ""}
        return formattedDate.convertToMonthYearDayFormat()
    }
}
