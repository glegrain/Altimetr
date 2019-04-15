//
//  AltitudeFormatter.swift
//  Altimetr
//
//  Created by Guillaume Legrain on 9/18/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import Foundation
import UIKit.UIFont

class AltitudeFormatter: NumberFormatter {

    var unit: UnitLength = .meters
    
    override init() {
        super.init()
        
        self.generatesDecimalNumbers = true
        self.maximumFractionDigits = 1
        self.usesGroupingSeparator = true
        self.groupingSize = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns a string containing the formatted value of the provided
    /// number object representing altitude.
    ///
    /// - Parameter number: altitude in meters
    /// - Returns: A string containing the formatted value of altitude number
    ///            using the receiver’s current settings.
    override func string(from altitude: NSNumber) -> String? {

        var altitudeMeasurement = Measurement(value: altitude.doubleValue, unit: UnitLength.meters)
        var unitString: String
        switch unit {
        case UnitLength.meters:
            unitString = " m"
        case UnitLength.feet:
            unitString = " ft"
            altitudeMeasurement.convert(to: .feet)
        default:
            fatalError("Not implemented")
        }
        // TODO: test description

        if let formattedNumber = super.string(from: NSNumber(value: altitudeMeasurement.value)) {
            return formattedNumber + unitString
        }

        return nil
    }
    
    func mutableAttributtedString(from altitude: Double) -> NSMutableAttributedString {

        let altitudeStr = self.string(from: NSNumber(value: altitude))!
        
        // if the altitude string has a decimal, make it smaller
        let altitudeString = NSMutableAttributedString(string: altitudeStr)
        let decimalSeparatorsSet = CharacterSet(charactersIn: self.decimalSeparator!)
        if let decimalSeparatorRange = altitudeStr.rangeOfCharacter(from: decimalSeparatorsSet) {
            let decimalSeparatorPosition =
                altitudeStr.distance(
                    from: altitudeStr.startIndex,
                    to: decimalSeparatorRange.lowerBound
            )
            let rangeToChange = NSMakeRange(decimalSeparatorPosition, 1 + maximumFractionDigits)
            altitudeString.addAttribute(
                NSAttributedString.Key.font,
                value: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.ultraLight),
                range: rangeToChange
            )
        }

        return altitudeString
    }
    
}
