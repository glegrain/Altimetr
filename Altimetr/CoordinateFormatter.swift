//
//  CoordinateFormatter.swift
//  Altimetr
//
//  Created by Guillaume Legrain on 9/20/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import Foundation
import CoreLocation

class CoordinateFormatter: Formatter {

    // Formats:
    //  - DMS: Degree Minutes Seconds (e.g. 40° 26' 46" N, 79° 58' 56" W)
    //  - DDM: Degree Decimal Minutes (e.g. 40° 26.767' N, 79° 58.933' W)
    //  - DD: Decimal Degres (e.g. 40.446° N, 79.982° W)
    //  - TODO: Google Plus Code (Experimental)
    enum NSFormattingFormatStyle: Int {
        case degreesMinutesSeconds
        case degreesDecimalMinutes
        case decimalDegrees
    }

    var unitStyle: Formatter.UnitStyle =  Formatter.UnitStyle.short
    var formatStyle: NSFormattingFormatStyle = NSFormattingFormatStyle.degreesMinutesSeconds
    var maximumSecondsFractionDigits = 0 // affects DMS format
    var maximumMinutesFractionDigits = 3 // affects DDM format
    var maximumDegreesFractionDigits = 6 // affects DD

    func string(from coordinate: CLLocationCoordinate2D) -> (String) {

        var north: String
        var south: String
        var east: String
        var west: String

        switch unitStyle {
        case .short:
            north = "N"
            south = "S"
            east = "E"
            west = "W"
        case .medium, .long:
            north = "north"
            south = "south"
            east = "east"
            west = "west"
        }
        let latitudeString = string(fromLocationDegrees: coordinate.latitude)
            + " " + (coordinate.latitude > 0 ? north:south)
        let longitudeString = string(fromLocationDegrees: coordinate.longitude)
            + " " + (coordinate.longitude > 0 ? east:west)
        return latitudeString + ", " + longitudeString
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        // TODO
        // NSFormattingError
        return false
    }

    func string(fromLocationDegrees locationDegrees: CLLocationDegrees) -> (String) {
        let degrees = fabs(locationDegrees)
        let minutes = (fabs(degrees) - floor(fabs(degrees))) * 60
        let seconds = (minutes - floor(minutes)) * 60
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1

        switch formatStyle {
        case .degreesMinutesSeconds:
            numberFormatter.maximumFractionDigits = maximumSecondsFractionDigits
            let formattedSeconds = numberFormatter.string(from: NSNumber(value: seconds))
            return "\(Int(degrees))° \(Int(minutes))' \(formattedSeconds!)\""
        case .degreesDecimalMinutes:
            numberFormatter.maximumFractionDigits = maximumMinutesFractionDigits
            let formattedMinutes = numberFormatter.string(from: NSNumber(value: minutes))
            return "\(Int(degrees))° \(formattedMinutes!)'"
        case .decimalDegrees:
            numberFormatter.maximumFractionDigits = maximumDegreesFractionDigits
            let formattedDegrees = numberFormatter.string(from: NSNumber(value: degrees))
            return "\(formattedDegrees!)°"
        }
    }
}
