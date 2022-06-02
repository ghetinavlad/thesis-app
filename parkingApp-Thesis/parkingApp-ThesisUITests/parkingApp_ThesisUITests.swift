//
//  parkingApp_ThesisUITests.swift
//  parkingApp-ThesisUITests
//
//  Created by vladut on 5/13/22.
//

import XCTest
import Foundation
import SwiftUI


class parkingApp_ThesisUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testAddParkingSpotSuccessUITesting() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["plus"].tap()
        app.buttons["upload"].tap()
        app.sheets["Select a method for upload"].scrollViews.otherElements.buttons["Photo Library"].tap()
        app.scrollViews.otherElements.images["Photo, April 22, 2022, 10:14 PM"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["15 - 30 mins"].tap()
        elementsQuery.buttons["Add parking spot"].tap()
    }
     
    

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
