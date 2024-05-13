//
//  PersistanceManager.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let saved = "saved"
    }
    
    static func updateWith(article: Article, actionType: PersistanceActionType, completed: @escaping (ACError?) -> Void) {
        retrieveSaved { result in
            switch result {
            case .success(let articles):
                var retrievedSaved = articles
                switch actionType {
                case .add:
                    guard !retrievedSaved.contains(article) else {
                        completed(.alreadyInSaved)
                        return
                    }
                    
                    retrievedSaved.append(article)
                case .remove:
                    retrievedSaved.removeAll(where: { $0.title == article.title } )
                }
                
                completed(saveArticles(articles: retrievedSaved))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveSaved(completed: @escaping(Result<[Article], ACError>) -> Void) {
        guard let savedData = defaults.object(forKey: Keys.saved) as? Data else {
    //MARK: Users first time trying to access saved news.
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let articles = try decoder.decode([Article].self, from: savedData)
            
            completed(.success(articles))
        } catch {
            completed(.failure(.unableToSave))
        }
    }
    
    static func saveArticles(articles: [Article]) -> ACError? {
        do {
            let encoder = JSONEncoder()
            let encodedSaved = try encoder.encode(articles)
            defaults.setValue(encodedSaved, forKey: Keys.saved)
            return nil
        } catch {
            return ACError.unableToSave
        }
    }
    
    static func isSaved(article: Article , completed: @escaping(Result<Bool, ACError>) -> Void) {
        retrieveSaved { result in
            switch result {
            case .success(let success):
                let retrievedSaveds = success
                if retrievedSaveds.contains(where: { $0.title == article.title } ) {
                    completed(.success(true))
                    return
                } else {
                    completed(.success(false))
                    return
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
}

