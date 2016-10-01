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
    //  - DMS: Degree Minutes Seconds (e.g. 40º 26' 46" N, 79º 58' 56" W)
    //  - DDM: Degree Decimal Minutes (e.g. 40º 26.767' N, 79º 58.933' W)
    //  - Decimal Degres (e.g. 40.446º N, 79.982º W)
    //  - TODO: Google Plus Code (Experimental)
    enum NSFormattingFormatStyle: Int {
        case DMS
        case DDM
        case Decimal
    }

    var unitStyle: NSFormattingUnitStyle =  NSFormattingUnitStyle.Short
    var formatStyle: NSFormattingFormatStyle = NSFormattingFormatStyle.DMS
    var maximumSecondsFractionDigits = 0 // affects DMS format
    var maximumMinutesFractionDigits = 3 // affects DDM format
    var maximumDegreesFractionDigits = 6 // affects Decimal format

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

        switch formatStyle {
        case .DMS:
            numberFormatter.maximumFractionDigits = maximumSecondsFractionDigits
            let formattedSeconds = numberFormatter.stringFromNumber(seconds)
            return "\(Int(degrees))º \(Int(minutes))' \(formattedSeconds!)\""
        case .DDM:
            numberFormatter.maximumFractionDigits = maximumMinutesFractionDigits
            let formattedMinutes = numberFormatter.stringFromNumber(minutes)
            return "\(Int(degrees))º \(formattedMinutes!)'"
        case .Decimal:
            numberFormatter.maximumFractionDigits = maximumDegreesFractionDigits
            let formattedDegrees = numberFormatter.stringFromNumber(degrees)
            return "\(formattedDegrees!)º"
        }
    }
}