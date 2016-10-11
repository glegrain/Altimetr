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

    fileprivate let formatter = CoordinateFormatter()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConvertToDMS() {
        let coordinates = CLLocationCoordinate2D(latitude: 45.934613, longitude: 6.970240)
        let result = formatter.string(from: coordinates)
        XCTAssertEqual(result, "45° 56' 5\" N, 6° 58' 13\" E")
    }

    func testConvertToDMSWithNegativeLongitude() {
        let coordinates = CLLocationCoordinate2D(latitude: 40.446111, longitude: -79.982222)
        let result = formatter.string(from: coordinates)
        XCTAssertEqual(result, "40° 26' 46\" N, 79° 58' 56\" W")
    }

    func testConvertToDDM() {
        formatter.formatStyle = .degreesDecimalMinutes
        let coordinates = CLLocationCoordinate2D(latitude: 45.934613, longitude: 6.970240)
        let result = formatter.string(from: coordinates)
        XCTAssertEqual(result, "45° 56.077' N, 6° 58.214' E")
    }

    func testConvertToDD() {
        formatter.formatStyle = .decimalDegrees
        let coordinates = CLLocationCoordinate2D(latitude: 45.934613, longitude: 6.970240)
        let result = formatter.string(from: coordinates)
        XCTAssertEqual(result, "45.934613° N, 6.97024° E")
    }
    
}
