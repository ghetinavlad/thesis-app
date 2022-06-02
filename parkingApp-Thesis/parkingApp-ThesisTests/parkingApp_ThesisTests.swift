//
//  parkingApp_ThesisTests.swift
//  parkingApp-ThesisTests
//
//  Created by vladut on 5/13/22.
//

import XCTest
import SwiftUI
import Foundation
@testable import parkingApp_Thesis
let TEST_LATITUDE = 46.770439
let TEST_LONGITUDE = 23.591423

class parkingApp_ThesisTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddParkingSpotSuccessUnitTesting() {
        let vm = MapViewModel()
        vm.addedSuccessfully = false
        vm.addParkingSpot(
            occupationRate: 2, zone: "1", note: "test", image: UIImage(named: "test"),
            latitude: TEST_LATITUDE, longitude: TEST_LONGITUDE, reporter: "test")
        XCTAssertTrue(vm.addedSuccessfully)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
