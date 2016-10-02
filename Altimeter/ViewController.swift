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
    @IBOutlet weak var coordsLabel: UILabel!
    @IBOutlet weak var verticalAccuracyProgress: SignalStrengthView!
    @IBOutlet weak var horizontalAccuracyProgress: SignalStrengthView!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    private let locationManager = CLLocationManager()
    private let altitudeFormatter = AltitudeFormatter()

    private var location: CLLocation? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Request the appropriate type of authorization from the user.
        locationManager.requestWhenInUseAuthorization()

        // Assign Core Location Manager delegation
        locationManager.delegate = self

        // NOTE: location manager will start updating location in the locationManager:didChangeAuthorizationStatus delegate method

    }

    // MARK: - Core Location Manager Delegate

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Configure location services (Activity Type and Accuracy)
        // location updates to be paused only when the user does not move a significant distance over a period of time. For background mode
        //  gives the system the opportunity to save power in situations where the user's location is not likely to be changing.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
        locationManager.pausesLocationUpdatesAutomatically = true
        // locationManager.allowsBackgroundLocationUpdates = true

        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }

        // Set fake altitude and location for simulator
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let fakeLocation = CLLocation(
                coordinate: CLLocationCoordinate2D(latitude: 45.934613, longitude: 6.970240),
                altitude: 4122.3,
                horizontalAccuracy: 20,
                verticalAccuracy: 5,
                timestamp: NSDate(timeIntervalSince1970: 1462782883)
            )
            self.location = fakeLocation
        #endif
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        var alert: UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }

        switch CLLocationManager.authorizationStatus() {
        case .Denied, .Restricted:
            alert = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get your altitude, please open this app's settings and set location access to 'Always' or 'While Using the App.",
                preferredStyle: .Alert
            )
            alert.addAction(cancelAction)
            alert.addAction(openAction)
            self.locationManager.stopUpdatingLocation()
        default:
            alert = UIAlertController(title: "Error", message:"Your location could not be retreived.", preferredStyle: .Alert)
            alert.addAction(cancelAction)
            // The location manager does not stop updating location because the signal might come back
        }
        presentViewController(alert, animated: true, completion: nil)

        self.location = nil

    }

    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print("Paused location updates")
    }

    // MARK: - UI

    private func updateUI() {

        // Disable share button if location is unavailable
        shareButton.enabled = (location != nil)

        altitudeLabel.attributedText = altitudeDescription

        coordsLabel.text = coordinatesDescription

        verticalAccuracyLabel.text! = verticalAccuracyDescription
        horizontalAccuracyLabel.text! = horizontalAccuracyDescription

        if location != nil {
            verticalAccuracyProgress.setProgress(Float(location!.verticalAccuracy), animated: true)
            horizontalAccuracyProgress.setProgress(Float(location!.horizontalAccuracy), animated: true)
        } else {
            verticalAccuracyProgress.setProgress(0, animated: true)
            horizontalAccuracyProgress.setProgress(0, animated: true)
        }

    }

    private var altitudeDescription: NSAttributedString {
        // Create formatted altitude string
        if let altitude = location?.altitude {
             return altitudeFormatter.mutableAttributtedStringFromLocationDistance(altitude)
        } else {
            // Replace altitude label with a "No data" text
            let attributes = [
                NSFontAttributeName: UIFont.systemFontOfSize(17),
                NSForegroundColorAttributeName: UIColor.darkGrayColor()
            ]
            return NSAttributedString(string: "No data", attributes: attributes)
        }
    }

    // Create accuracy descriptions
    // NOTE: negative value in accuracy indicates that the altitude value is invalid.
    //       Accuracy is in meters.
    private var verticalAccuracyDescription: String {
        if let verticalAccuracy = location?.verticalAccuracy where verticalAccuracy > 0 {
            var description = "Vertical accuracy: "
            if altitudeFormatter.unit == .Feet {
                description += "± \(lround(verticalAccuracy * 3.28084)) ft"
            } else  {
                description += "± \(lround(verticalAccuracy)) m"
            }
            return description
        } else {
             return "Altitude invalid"
        }
    }

    private var horizontalAccuracyDescription: String {
        if let horizontalAccuracy = location?.horizontalAccuracy where horizontalAccuracy > 0 {
            var description = "Horizontal accuracy: "
            if altitudeFormatter.unit == .Feet {
                description += "± \(lround(horizontalAccuracy * 3.28084)) ft"
            } else {
                description += "± \(lround(horizontalAccuracy)) m"
            }
            return description
        } else {
            return "Location invalid"
        }
    }

    private var coordinatesDescription: String? {
        if let coordinate = location?.coordinate {
            return CoordinateFormatter().stringFromLocationCoordinate(coordinate)
        }
        return nil
    }

    @IBAction func changeAltitudeUnit() {
        // TODO: save to user defaults
        if altitudeFormatter.unit == .Meters {
            altitudeFormatter.unit = .Feet
        } else {
            altitudeFormatter.unit = .Meters
        }

        updateUI()

    }

    @IBAction func share(sender: AnyObject) {
        if location != nil {
            let activityItems = [CoordinateFormatter().stringFromLocationCoordinate(location!.coordinate)]
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityViewController.title = "Share my location"
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
