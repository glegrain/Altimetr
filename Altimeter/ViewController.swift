//
//  ViewController.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 9/18/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var verticalAccuracyLabel: UILabel!
    @IBOutlet weak var horizontalAccuracyLabel: UILabel!
    @IBOutlet weak var coordsLabel: UITextField!
    @IBOutlet weak var verticalAccuracyProgress: UIProgressView!
    @IBOutlet weak var horizontalAccuracyProgress: UIProgressView!
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Get the current authorization status for app
        // TODO: Check what happens when authorizationStatus() is restricted or denied
        
        // Assign Core Location Manager delegation
        locationManager.delegate = self
        
        // Request the appropriate type of authorization from the user.
        locationManager.requestWhenInUseAuthorization()
        
        // if iOS 9.0
        //locationManager.allowsBackgroundLocationUpdates = true
        
        // Configure location service
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Core Location Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Format altitude
            let altitudeFormatter = AltitudeFormatter()
            let altitudeString = altitudeFormatter.mutableAttributtedStringFromLocationDistance(location.altitude)
            
            // Set accuracy labels
            // NOTE: negative value in accuracy indicates that the altitude value is invalid.
            //       Accuracy is in meters.
            var verticalAccuracyString = ""
            if location.verticalAccuracy < 0 {
                verticalAccuracyString = "Not available"
            } else {
                verticalAccuracyString = "± \(lround(location.verticalAccuracy)) m"
            }
            #if (TARGET_IPHONE_SIMULATOR)
                verticalAccuracyString = "± 5 m"
            #endif
            
            // Update UI
            verticalAccuracyLabel.text! = "Vertical accuracy: \(verticalAccuracyString)"
            horizontalAccuracyLabel.text! = "Horizontal accuracy: ± \(lround(location.horizontalAccuracy)) m"
            updateProgressBar(horizontalAccuracyProgress, withAccuracy: location.horizontalAccuracy)
            updateProgressBar(verticalAccuracyProgress, withAccuracy: location.verticalAccuracy)
            
            #if (TARGET_IPHONE_SIMULATOR)
                // Set Progress bars and altitude string for debug
                updateProgressBar(verticalAccuracyProgress, withAccuracy: 1000)
                updateProgressBar(horizontalAccuracyProgress, withAccuracy: 1000)
                altitudeString = altitudeFormatter.mutableAttributtedStringFromLocationDistance(0)
            #endif
            
            altitudeLabel.attributedText = altitudeString
            coordsLabel.text = "\(location.coordinate.latitude) \(location.coordinate.longitude)"
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error occured: \(error.localizedDescription).")
        // TODO:
//        if error.code == kCLErrorDenied {
//            self.locationManager.stopUpdatingLocation()
//        }
//        else if error.code == kCLErrorLocationUnknown {
//            // This can occur when Core Location is first starting up and isn’t able to immediately determine its position
//            return
//            // retry
//        }
//        
//        // TODO: Update to new Alert view
//        var alertView = UIAlertView(title: "Error", message: error!.localizedDescription, delegate: self, cancelButtonTitle: "OK")
//        alertView.show()
    }
    
    // MARK: - UI Configuration
    
    func updateProgressBar(progressView: UIProgressView, withAccuracy accuracy: CLLocationDistance) {
        var progress: Float
        if accuracy < 100 && accuracy > 0 {
            progress = 1 - Float(accuracy) / 100
        } else {
            progress = 0
        }
        progressView.setProgress(progress, animated: true)
        if accuracy < 10 {
            progressView.progressTintColor! = UIColor.greenColor()
        } else if accuracy > 100 {
            progressView.progressTintColor! = UIColor.redColor()
        } else if accuracy < 20 {
            progressView.progressTintColor! = UIColor.yellowColor()
        } else {
            progressView.progressTintColor! = UIColor.orangeColor()
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
