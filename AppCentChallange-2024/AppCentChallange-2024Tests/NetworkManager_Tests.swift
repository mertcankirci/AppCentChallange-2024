//
//  NetworkManager_Tests.swift
//  AppCentChallange-2024Tests
//
//  Created by Mertcan Kırcı on 12.05.2024.
//

import XCTest
@testable import AppCentChallange_2024

class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetNewsSuccessfulResponse() {
        let expectation = XCTestExpectation(description: "Fetched news data successfully.")
        let query = "technology"
        let page = 1
        
        sut.getNews(for: query, page: page) { result in
            switch result {
            case .success(let newsResponse):
                XCTAssertNotNil(newsResponse.articles)
                XCTAssertGreaterThan(newsResponse.articles?.count ?? 0, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected successful response, but got failure with error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetNewsInvalidQuery() {
        let expectation = XCTestExpectation(description: "Expected failure fulfilled.")
        let query = ""
        let page = 1
        
        sut.getNews(for: query, page: page) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure due to invalid query")
            case .failure(let error):
                XCTAssertEqual(error, .invalidQuery)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }

    func testGetNewsPerformance() {
        let query = "technology"
        let page = 1
        
        self.measure(
            metrics: [
              XCTClockMetric(),
              XCTCPUMetric(),
              XCTStorageMetric(),
              XCTMemoryMetric()
            ]
        ) {
            sut.getNews(for: query, page: page) { _ in
                
            }
        }
    }

}
