//
//  CoordinateFormatter.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 9/20/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import Foundation
import CoreLocation

class CoordinateFormatter: NSFormatter {

    // Formats:
    //  - DMS: Degree Minutes Seconds (e.g. 40° 26' 46" N, 79° 58' 56" W)
    //  - DDM: Degree Decimal Minutes (e.g. 40° 26.767' N, 79° 58.933' W)
    //  - DD: Decimal Degres (e.g. 40.446° N, 79.982° W)
    //  - TODO: Google Plus Code (Experimental)
    enum NSFormattingFormatStyle: Int {
        case DegreesMinutesSeconds
        case DegreesDecimalMinutes
        case DecimalDegrees
    }

    var unitStyle: NSFormattingUnitStyle =  NSFormattingUnitStyle.Short
    var formatStyle: NSFormattingFormatStyle = NSFormattingFormatStyle.DegreesMinutesSeconds
    var maximumSecondsFractionDigits = 0 // affects DMS format
    var maximumMinutesFractionDigits = 3 // affects DDM format
    var maximumDegreesFractionDigits = 6 // affects DD

    func stringFromLocationCoordinate(coordinate: CLLocationCoordinate2D) -> (String) {

        var north: String
        var south: String
        var east: String
        var west: String

        switch unitStyle {
        case .Short:
            north = "N"
            south = "S"
            east = "E"
            west = "W"
        case .Medium, .Long:
            north = "north"
            south = "south"
            east = "east"
            west = "west"
        }
        let latitudeString = stringFromLocationDegrees(coordinate.latitude)
            + " " + (coordinate.latitude > 0 ? north:south)
        let longitudeString = stringFromLocationDegrees(coordinate.longitude)
            + " " + (coordinate.longitude > 0 ? east:west)
        return latitudeString + ", " + longitudeString
    }

    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        // TODO
        // NSFormattingError
        return false
    }

    func stringFromLocationDegrees(locationDegrees: CLLocationDegrees) -> (String) {
        let degrees = fabs(locationDegrees)
        let minutes = (fabs(degrees) - floor(fabs(degrees))) * 60
        let seconds = (minutes - floor(minutes)) * 60
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumIntegerDigits = 1

        switch formatStyle {
        case .DegreesMinutesSeconds:
            numberFormatter.maximumFractionDigits = maximumSecondsFractionDigits
            let formattedSeconds = numberFormatter.stringFromNumber(seconds)
            return "\(Int(degrees))° \(Int(minutes))' \(formattedSeconds!)\""
        case .DegreesDecimalMinutes:
            numberFormatter.maximumFractionDigits = maximumMinutesFractionDigits
            let formattedMinutes = numberFormatter.stringFromNumber(minutes)
            return "\(Int(degrees))° \(formattedMinutes!)'"
        case .DecimalDegrees:
            numberFormatter.maximumFractionDigits = maximumDegreesFractionDigits
            let formattedDegrees = numberFormatter.stringFromNumber(degrees)
            return "\(formattedDegrees!)°"
        }
    }
}