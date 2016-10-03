//
//  AltitudeFormatter.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 9/18/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import Foundation
import UIKit.UIFont

class AltitudeFormatter: NSNumberFormatter {

    enum AltitudeFormatterUnit {
        case Meters
        case Feet
    }

    var unit: AltitudeFormatterUnit = .Meters
    
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
    
    func mutableAttributtedStringFromLocationDistance(altitude: Double) -> NSMutableAttributedString {

        var unitString: String
        var convertedAltitude: Double
        switch  unit{
        case .Meters:
            unitString = " m"
            convertedAltitude = altitude
        case .Feet:
            unitString = " ft"
            convertedAltitude = altitude * 3.28084
        }

        let altitudeStr = self.stringFromNumber(convertedAltitude)!.stringByAppendingString(unitString)
        
        // if the altitude string has a decimal, make it smaller
        let altitudeString = NSMutableAttributedString(string: altitudeStr)
        let decimalSeparatorsSet = NSCharacterSet(charactersInString: self.decimalSeparator!)
        if let decimalSeparatorRange = altitudeStr.rangeOfCharacterFromSet(decimalSeparatorsSet) {
            let decimalSeparatorPosition = altitudeStr.startIndex.distanceTo(decimalSeparatorRange.endIndex.predecessor())
            let rangeToChange = NSMakeRange(decimalSeparatorPosition, 1 + maximumFractionDigits)
            altitudeString.addAttribute(
                NSFontAttributeName,
                value: UIFont.systemFontOfSize(30, weight: UIFontWeightUltraLight),
                range: rangeToChange
            )
        }

        return altitudeString
    }
    
}