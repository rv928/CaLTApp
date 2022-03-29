//
//  CatListInteractorUnitTests.swift
//  CaLTAppTests
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import XCTest
@testable import CaLTApp

class CatListInteractorUnitTests: XCTestCase {

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
    
    func testFetchCatsCallsWorkerToFetch() {
        // Given
        let catWorkerSpy = WorkerSpy(cats: nil)
        let presenterSpy = PresenterSpy()
        
        let sut = CatListInteractor(presenter: presenterSpy, worker: catWorkerSpy)
        let exp = self.expectation(description: "myExpectation")
        
        let request = CatListModel.Request(limit: 10, page: 0)
        // When
        sut.fetchCatList(request: request)
        
        let queue = DispatchQueue(label: "com.admin.PikcUpLocations")
        let delay: DispatchTimeInterval = .seconds((5))
        queue.asyncAfter(deadline: .now() + delay) {
            XCTAssertTrue(true)
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 30){ [] error in
            print("X: async expectation")
            // Then
            XCTAssert(catWorkerSpy.fetchCatsCalled, "fetchCats() should ask the worker to fetch cats")
        }
    }
    
    func testFetchCatsCallsPresenterToFormatFetchedCats() {
        
        // Given
        let cats = Seeds().loadCatListFromJson()
        let presenterSpy = PresenterSpy()
        
        let catWorkerSpy = WorkerSpy(cats: cats)
        
        let sut = CatListInteractor(presenter: presenterSpy, worker: catWorkerSpy)
        let request = CatListModel.Request(limit: 10, page: 0)
        // When
        sut.fetchCatList(request: request)
        // Then
        XCTAssertEqual(presenterSpy.cats?.count,
                       cats?.count, "displayCatList() should ask the presenter to format the same amount of cats it fetched")
    }
}
