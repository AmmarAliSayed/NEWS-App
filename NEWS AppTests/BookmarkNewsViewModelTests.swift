//
//  BookmarkNewsViewModelTests.swift
//  NEWS AppTests
//
//  Created by Macbook on 12/07/2021.
//

import XCTest
@testable import NEWS_App

class BookmarkNewsViewModelTests: XCTestCase {
    var bookmarkNewsViewModel: BookmarkNewsViewModel!
    var coreDataStack: CoreDataTestStack!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = CoreDataTestStack()
        bookmarkNewsViewModel = BookmarkNewsViewModel(mainContext: coreDataStack.mainContext)
        
    }
    func testCallFuncToAddNewsToCoreData(){
       //  bookmarkNewsViewModel?.BookmarkNewsCoreData = []
        bookmarkNewsViewModel.callFuncToAddNewsToCoreData(title: "ahly wins", img: "ahly", newsLink: "https//")
        bookmarkNewsViewModel.callFuncToFetchDataFromCoreData()
        if let bookmarkNews = bookmarkNewsViewModel?.BookmarkNewsCoreData{
            XCTAssertEqual(bookmarkNews.count, 1)
        }else{
            XCTAssertNil(bookmarkNewsViewModel.BookmarkNewsCoreData)
        }
        
    }

    func testDeleteFromCoreData(){
        bookmarkNewsViewModel.callFuncToAddNewsToCoreData(title: "ahly wins", img: "ahly", newsLink: "myURL")
        bookmarkNewsViewModel.deleteFromCoreData(with: "myURL")
        bookmarkNewsViewModel.callFuncToFetchDataFromCoreData()
        if let bookmarkNews = bookmarkNewsViewModel?.BookmarkNewsCoreData{
            XCTAssertEqual(bookmarkNews.count, 0)
        }else{
            XCTAssertNil(bookmarkNewsViewModel.BookmarkNewsCoreData)
        }
    }
    func testSearchInCoreData(){
        bookmarkNewsViewModel.callFuncToAddNewsToCoreData(title: "ahly wins", img: "ahly", newsLink: "myURL")
        bookmarkNewsViewModel.searchInCoreData(with: "ahly")
        if let filterdNews = bookmarkNewsViewModel?.filterdBookmarkNewsCoreData{
            XCTAssertEqual(filterdNews.count, 1)
        }else{
            XCTAssertNil(bookmarkNewsViewModel.filterdBookmarkNewsCoreData)
        }
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        bookmarkNewsViewModel = nil
    }

   

}
