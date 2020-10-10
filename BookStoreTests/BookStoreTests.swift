//
//  BookStoreTests.swift
//  BookStoreTests
//
//  Created by Kaio Dantas on 09/10/20.
//

import XCTest
@testable import BookStore

class BookStoreTests: XCTestCase {

    
//    var systemUnderTest: ViewController
    
    lazy var systemUnderTest: ViewController = {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }()
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_CanInstantiateViewController() {
        
        XCTAssertNotNil(systemUnderTest)
    }
    
    func testSUT_HasItemsForCollectionView() {
        
        XCTAssertNotNil(systemUnderTest.bookList)
    }
    
    
    func testSUT_ConformsToCollectionViewDataSource() {
        
        XCTAssert(systemUnderTest.conforms(to: UICollectionViewDataSource.self))
    }
    
    
    func testSUT_ConformsToCollectionViewDelegateFlowLayout () {
        
        XCTAssert(systemUnderTest.conforms(to: UICollectionViewDelegateFlowLayout.self))
  
    }
    
    
    
    var error: Error? {
        didSet {
            print("Error on request")
        }
    }
    
    
    
    func testValidSearch() {
        
        let searchText = "ios"
        let page = 0
        let perpage = 50
        
        
        
        let dataService = DataService()
        dataService.requestBooksList(with: searchText, maxResults: perpage, startIndex: page, completion: { (booksResult, error) in
            if let error = error {
                self.error = error;
                XCTFail("Error on request")
                return
            }
            
            XCTAssert(true, "Success")
            
        })
        
    }
    
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
