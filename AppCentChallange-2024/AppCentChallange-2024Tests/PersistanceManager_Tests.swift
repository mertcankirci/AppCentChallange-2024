//
//  PersistanceManager_Tests.swift
//  AppCentChallange-2024Tests
//
//  Created by Mertcan Kırcı on 12.05.2024.
//

import XCTest
@testable import AppCentChallange_2024

class PersistanceManager_Tests: XCTestCase {
    
    let mockArticle = Article(source: Source(id: "1", name: "Mock source"), author: "Mock author", title: "Mock title", description: "Mock descripiton", url: "MockUrl", urlToImage: "MockUrlToImage", publishedAt: "Mock Date", content: "Mock content")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testUpdateSavedArticles() {
        let expectation = XCTestExpectation(description: "Updated articles successfully.")
        
        PersistanceManager.updateWith(article: mockArticle, actionType: .add) { error in
            XCTAssertNil(error, "Error adding article: \(error?.localizedDescription ?? "")")
        }
        
        PersistanceManager.isSaved(article: mockArticle) { result in
            switch result {
            case .success(let isSaved):
                XCTAssertTrue(isSaved, "Article should be saved")
            case .failure(let error):
                XCTFail("Error checking if article is saved: \(error.localizedDescription)")
            }
        }
        
        PersistanceManager.updateWith(article: mockArticle, actionType: .remove) { error in
            XCTAssertNil(error, "Error removing article: \(error?.localizedDescription ?? "")")
        }
        
        PersistanceManager.isSaved(article: mockArticle) { result in
            switch result {
            case .success(let isSaved):
                XCTAssertFalse(isSaved, "Article should not be saved")
            case .failure(let error):
                XCTFail("Error checking if article is saved: \(error.localizedDescription)")
            }
        }
        expectation.fulfill()
    }
    
    func testSaveArticles() {
        let expectation = XCTestExpectation(description: "Saved article successfully.")
        let articles = [mockArticle]
        let saveError = PersistanceManager.saveArticles(articles: articles)
        XCTAssertNil(saveError, "Error saving articles: \(saveError?.localizedDescription ?? "")")
        expectation.fulfill()
    }
    
    func testRemoveArtciles() {
        let expectation = XCTestExpectation(description: "Removed article successfully.")
        PersistanceManager.updateWith(article: mockArticle, actionType: .remove) { error in
            XCTAssertNil(error, "Error removing article: \(error?.localizedDescription ?? "")")
        }
        expectation.fulfill()
    }
    
    func testRetrieveArticles() {
        let expectation = XCTestExpectation(description: "Retrieved saved data successfully.")
        PersistanceManager.retrieveSaved { result in
            switch result {
            case .success(_):
    //MARK: I'm not checking if articles are empty in the success case because if the user hasn't saved anything before, articles will be empty. The important thing is that no errors are thrown.
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error retrieving saved articles: \(error.localizedDescription)")
            }
        }
    }
    
    func testAddArticlePerformance() {
        
        self.measure(
            metrics: [
              XCTClockMetric(),
              XCTCPUMetric(),
              XCTStorageMetric(),
              XCTMemoryMetric()
            ]
        ) {
            PersistanceManager.updateWith(article: mockArticle, actionType: .add) { _ in
                
            }
        }
    }
    
    func testRemoveArticlePerformance() {
        self.measure(
            metrics: [
              XCTClockMetric(),
              XCTCPUMetric(),
              XCTStorageMetric(),
              XCTMemoryMetric()
            ]
        ) {
            PersistanceManager.updateWith(article: mockArticle, actionType: .remove) { _ in
                
            }
        }
    }
}
