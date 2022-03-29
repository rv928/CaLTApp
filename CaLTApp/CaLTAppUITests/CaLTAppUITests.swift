//
//  CaLTAppUITests.swift
//  CaLTAppUITests
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import XCTest

class CaLTAppUITests: XCTestCase {

    var customKeywordsUtils: CustomKeywordsUtils? = CustomKeywordsUtils.init()
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        customKeywordsUtils?.deleteMyApp()
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testForCatListToDetailScreen() {
        
        // Find Plus button
        let tableView = app.tables["tableView--catListTableView"]
        XCTAssert(tableView.waitForExistence(timeout: 5))
        
        // Load Cat TableView
        let catListTableView = app.tables.matching(identifier: "tableView--catListTableView")
        let catCell = catListTableView.cells.element(matching: .cell, identifier: "CatListCell0")
        customKeywordsUtils?.swipeToFindElement(app: app, element: catCell, count: 2)
        
        let catName: String = "Abyssinian"
        
        _ = customKeywordsUtils?.swipeToExpectedCellByText(collectionView: catListTableView.cells["CatListCell0"].firstMatch, expectedText: catName, loopCount: 1, swipeSide: .up)
        
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
    
        _ = app.staticTexts.matching(identifier: catName)
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
