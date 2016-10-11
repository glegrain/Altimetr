//
//  Settings.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 10/11/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import Foundation

class Settings {

    fileprivate struct Keys {
        static let coordinatesFormat = "coordinatesFormat"
        static let unit = "unit"
    }

    var distanceUnit: UnitLength {
        get {
            // Attempt to load user preferences
            // NOTE: UserDefaults caches the information
            if let unitName = UserDefaults.standard.string(forKey: Keys.unit) {
                if unitName == "meters" {
                    return .meters
                } else if unitName == "feet" {
                    return .feet
                }
            }
            return .meters
        } set {
            // Update user defaults
            let unitName = (newValue == .meters) ? "meters" : "feet"
            UserDefaults.standard.set(unitName, forKey: Keys.unit)
        }
    }

    // Use raw values??
    var coordinatesFormat: CoordinateFormatter.NSFormattingFormatStyle {
        get {
            // NOTE: UserDefaults caches the information
            let formatIndex = UserDefaults.standard.integer(forKey: Keys.coordinatesFormat)
            switch formatIndex {
            case 0:
                return CoordinateFormatter.NSFormattingFormatStyle.degreesMinutesSeconds
            case 1:
                return CoordinateFormatter.NSFormattingFormatStyle.degreesDecimalMinutes
            case 2:
                return CoordinateFormatter.NSFormattingFormatStyle.decimalDegrees
            default:
                fatalError("No match")
            }
        }
        set {
            var formatIndex: Int
            switch newValue {
            case .degreesMinutesSeconds:
                formatIndex = 0
            case .degreesDecimalMinutes:
                formatIndex = 1
            case .decimalDegrees:
                formatIndex = 2
            }
            UserDefaults.standard.set(formatIndex, forKey: Keys.coordinatesFormat)
        }
    }
}
