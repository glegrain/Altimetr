//
//  SignalStrengthView.swift
//  Altimetr
//
//  Created by Guillaume Legrain on 9/18/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import UIKit

@IBDesignable
class SignalStrengthView: UIProgressView {
    
    // set bar progress and color according to signal accuracy
    override func setProgress(_ progress: Float, animated: Bool) {
        let accuracy = progress
        var barProgress: Float
        
        if accuracy < 100 && accuracy > 0 {
            barProgress = 1 - Float(accuracy) / 100
        } else {
            barProgress = 0
        }
        super.setProgress(barProgress, animated: animated)
        
        if accuracy < 10 {
            progressTintColor! = UIColor.green
        } else if accuracy > 100 {
            progressTintColor! = UIColor.red
        } else if accuracy < 20 {
            progressTintColor! = UIColor.yellow
        } else {
            progressTintColor! = UIColor.orange
        }
    }
}
