//
//  NewsServiceTests.swift
//  NEWS AppTests
//
//  Created by Macbook on 07/07/2021.
//

import XCTest
@testable import NEWS_App
class NewsServiceTests: XCTestCase {

    var mockNewsService : MockNewsService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNewsService = MockNewsService(shouldReturnError: false)
    }
    
    func testGetMovies() {
      //  var expectationObj = expectation(description: "wait for response")
        mockNewsService.fetchNewsData { (allNews, error) in
            if let news = allNews{
            //    expectationObj.fulfill()
                XCTAssertEqual(news.articles.count, 2)
            }else{
                XCTFail()
            }
            
        }
        //wait for response
        //waitForExpectations(timeout: 3)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockNewsService = nil
    }

  

}
