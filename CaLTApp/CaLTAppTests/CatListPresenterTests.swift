//
//  CatListPresenterTests.swift
//  CaLTAppTests
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import XCTest
@testable import CaLTApp

class CatListPresenterTests: XCTestCase {

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

    // MARK: - Tests
    
    func testDisplayFetchedCatsCalledByPresenter() {
        // Given
        let viewControllerSpy = ViewControllerSpy()
        let sut = CatListPresenter(viewController: viewControllerSpy)
        // When
        sut.displayCatList(axCatList: [])
        // Then
        XCTAssert(viewControllerSpy.displayFetchedCatsCalled,
                  "displayCatList() should ask the view controller to display them")
    }
    
    func testPresentFetchedCatsShouldFormatFetchedCatsForDisplay() {
        // Given
        let viewControllerSpy = ViewControllerSpy()
        let sut = CatListPresenter(viewController: viewControllerSpy)
        guard let cats = Seeds().loadCatListFromJson() else { return }
        // When
        sut.displayCatList(axCatList: cats)
        // Then
        let displayedCats = viewControllerSpy.cats
        
        XCTAssertEqual(displayedCats.count, cats.count,
                       "displayedCats() should ask the view controller to display same amount of cats it receive")
    }
}
