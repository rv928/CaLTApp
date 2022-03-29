//
//  CustomKeywordsUtils.swift
//  CaLTAppUITests
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/29.
//

import Foundation
import XCTest

enum SwipeSide {
    case left
    case right
    case up
    case down
}

class CustomKeywordsUtils {
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate,
                                                    object: element)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func waitAndTap(element: XCUIElement) {
        waitAndTap(element: element, timeout: 10)
    }
    
    func waitAndTap(element: XCUIElement, message: String) {
        waitAndTap(element: element, timeout: 10)
    }
    
    func waitAndTap(element: XCUIElement, timeout: Double, message: String = "") {
        let elementExist = element.waitForExistence(timeout: timeout)
        XCTAssert(elementExist, message)
        element.tap()
    }
    
    func waitUntilClickable(element: XCUIElement, timeout: Int) {
        var count: Int = 0
        element.waitForExistence(timeout: TimeInterval(timeout))
        while (!element.isHittable) {
            count += 1
            sleep(1)
            if count > timeout {
                break
            }
        }
    }
    
    func waitElementToAppear(element: XCUIElement, timeout: TimeInterval=5)->XCUIElement {
        let _ = element.waitForExistence(timeout: timeout)
        return element
    }
    
    
    func swipeToFindElement(app: XCUIApplication, element: XCUIElement, count: Int){
        var loop: Int = 0
        let elementExist = element.waitForExistence(timeout: 5)
        XCTAssert(elementExist)
        while (!element.isHittable && loop < count) {
            app.swipeUp()
            loop += 1
        }
    }
    
    func swipeToExpectedCellByText(collectionView: XCUIElement, expectedText: String, loopCount: Int, swipeSide: SwipeSide) -> XCUIElement? {
        //method for cell can't clickable. collectionview corousel
        let elementExist = collectionView.waitForExistence(timeout: 5)
        XCTAssert(elementExist)
        var count = max(loopCount, 0)
        
        while count != 0 {
            for index in 0..<collectionView.cells.countForHittables {
                let cell = collectionView.cells.element(boundBy: index)
                if cell.staticTexts[expectedText].exists, cell.staticTexts[expectedText].isHittable {
                    return cell
                }
            }
            switch(swipeSide) {
            case .left:
                collectionView.swipeLeft()
            case .right:
                collectionView.swipeRight()
            case .up:
                collectionView.swipeUp()
            case .down:
                collectionView.swipeDown()
            }
            count -= 1
        }
        return nil
    }
    
    func deleteMyApp() {
        XCUIApplication().terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let bundleDisplayName = "CaLTApp"

        let icon = springboard.icons[bundleDisplayName]
        if icon.exists {
            icon.press(forDuration: 1)

            let buttonRemoveApp = springboard.buttons["Remove App"]
            if buttonRemoveApp.waitForExistence(timeout: 5) {
                buttonRemoveApp.tap()
            } else {
                XCTFail("Button \"Remove App\" not found")
            }

            let buttonDeleteApp = springboard.alerts.buttons["Delete App"]
            if buttonDeleteApp.waitForExistence(timeout: 5) {
                buttonDeleteApp.tap()
            }
            else {
                XCTFail("Button \"Delete App\" not found")
            }

            let buttonDelete = springboard.alerts.buttons["Delete"]
            if buttonDelete.waitForExistence(timeout: 5) {
                buttonDelete.tap()
            }
            else {
                XCTFail("Button \"Delete\" not found")
            }
        }
    }
}

extension XCUIElementQuery {
    var countForHittables: Int {
        return Int(allElementsBoundByIndex.filter { $0.isHittable }.count)
    }
}
