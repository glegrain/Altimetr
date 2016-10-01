//
//  CoordinateFormatterTests.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 10/1/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import XCTest
@testable import Altimeter
import CoreLocation

class CoordinateFormatterTests: XCTestCase {

    private let formatter = CoordinateFormatter()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDMS() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let coordinates = CLLocationCoordinate2D(latitude: 40.446111, longitude: -79.982222)
        let result = formatter.stringFromLocationCoordinate(coordinates)
        XCTAssertEqual(result, "40º 26' 46\" N, 79º 58' 56\" W")
    }

    
}
