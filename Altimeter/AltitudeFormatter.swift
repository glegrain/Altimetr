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
    
    override init() {
        super.init()
        
        self.generatesDecimalNumbers = true
        self.maximumFractionDigits = 1
        self.usesGroupingSeparator = true
        self.groupingSeparator = " "
        self.groupingSize = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mutableAttributtedStringFromLocationDistance(altitude: Double) -> NSMutableAttributedString {
        let altitudeNumber = Int(altitude)
        let integerPartString = "\(CInt(altitudeNumber))"
        let integerPartLength = integerPartString.characters.count
        let hasDecimalPart = (altitude - Double(altitudeNumber)) >= 0.05 // for 1 fraction digit
        let unitString = " m"
        let altitudeStr = self.stringFromNumber(altitude)!.stringByAppendingString(unitString)
        
        // make decimal part smaller
        let altitudeString = NSMutableAttributedString(string: altitudeStr)
        if hasDecimalPart {
            let formattedIntegerPartLength = integerPartLength + integerPartLength / self.groupingSize
            altitudeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(30), range: NSMakeRange(formattedIntegerPartLength, 1 + self.maximumFractionDigits))
        }
        
        return altitudeString
    }
    
}