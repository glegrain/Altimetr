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
        
        // Request the appropriate type of authorization from the user.
        locationManager.requestWhenInUseAuthorization()
        
        // Assign Core Location Manager delegation
        locationManager.delegate = self
        
        // if iOS 9.0
        //locationManager.allowsBackgroundLocationUpdates = true
        
        // NOTE: location manager will start updating location in the locationManager:didChangeAuthorizationStatus delegate method

    }
    
    // MARK: - Core Location Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Configure location service
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
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
//        print("Error description: \(error.localizedDescription).")
//        print("Error suggestion: \(error.localizedRecoverySuggestion).")
//        print("Error failure reason: \(error.localizedFailureReason).")
//        print("Error recovery options: \(error.localizedRecoveryOptions).")
        
        var alert: UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .Denied, .Restricted:
            alert = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get your altitude, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert
            )
            alert.addAction(cancelAction)
            alert.addAction(openAction)
        default:
            alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
            alert.addAction(cancelAction)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        
        // Replace altitude label with a "Not data" text
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        altitudeLabel.attributedText = NSAttributedString(string: "No data", attributes: attributes)
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
