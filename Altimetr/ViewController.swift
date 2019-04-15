//
//  ViewController.swift
//  Altimetr
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

    fileprivate let locationManager = CLLocationManager()
    fileprivate let altitudeFormatter = AltitudeFormatter()
    fileprivate let coordinateFormatter = CoordinateFormatter()
    fileprivate var userDefaultsObserver: NSObjectProtocol?
    fileprivate let settings = Settings()

    fileprivate var location: CLLocation? {
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

        locationManager.startUpdatingLocation()

        // Observe Settings changes made to User Defaults
        userDefaultsObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: OperationQueue.main) { (notification) in
                self.updateUI()
        }

    }

    // MARK: - Core Location Manager Delegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Configure location services (Activity Type and Accuracy)
        // location updates to be paused only when the user does not move a significant distance over a period of time. For background mode
        //  gives the system the opportunity to save power in situations where the user's location is not likely to be changing.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.pausesLocationUpdatesAutomatically = true
        // locationManager.allowsBackgroundLocationUpdates = true

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }

        // Set fake altitude and location for simulator
        #if targetEnvironment(simulator)
            let fakeLocation = CLLocation(
                coordinate: CLLocationCoordinate2D(latitude: 45.934613, longitude: 6.970240),
                altitude: 4122.3,
                horizontalAccuracy: 20,
                verticalAccuracy: 5,
                timestamp: Date(timeIntervalSince1970: 1462782883)
            )
            self.location = fakeLocation
        #endif
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        var alert: UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            alert = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to get your altitude, please open this app's settings and set location access to 'Always' or 'While Using the App.",
                preferredStyle: .alert
            )
            alert.addAction(cancelAction)
            alert.addAction(openAction)
            self.locationManager.stopUpdatingLocation()
        default:
            alert = UIAlertController(title: "Error", message:"Your location could not be retreived.", preferredStyle: .alert)
            alert.addAction(cancelAction)
            // The location manager does not stop updating location because the signal might come back
        }
        present(alert, animated: true, completion: nil)

        self.location = nil

    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Paused location updates")
    }

    // MARK: - UI

    fileprivate func updateUI() {

        // Disable share button if location is unavailable
        shareButton.isEnabled = (location != nil)

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

    fileprivate var altitudeDescription: NSAttributedString {
        altitudeFormatter.unit = settings.distanceUnit
        if let altitude = location?.altitude {
            return altitudeFormatter.mutableAttributtedString(from: altitude)
        } else {
            // Replace altitude label with a "No data" text
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ]
            return NSAttributedString(string: "No data", attributes: attributes)
        }
    }

    // Create accuracy descriptions
    // NOTE: negative value in accuracy indicates that the altitude value is invalid.
    //       Accuracy is in meters.
    fileprivate var verticalAccuracyDescription: String {
        if let verticalAccuracy = location?.verticalAccuracy , verticalAccuracy > 0 {
            var description = "Vertical accuracy: "
            if settings.distanceUnit == .feet {
                description += "± \(lround(verticalAccuracy * 3.28084)) ft"
            } else  {
                description += "± \(lround(verticalAccuracy)) m"
            }
            return description
        } else {
             return "Altitude invalid"
        }
    }

    fileprivate var horizontalAccuracyDescription: String {
        if let horizontalAccuracy = location?.horizontalAccuracy , horizontalAccuracy > 0 {
            var description = "Horizontal accuracy: "
            if settings.distanceUnit == .feet {
                description += "± \(lround(horizontalAccuracy * 3.28084)) ft"
            } else {
                description += "± \(lround(horizontalAccuracy)) m"
            }
            return description
        } else {
            return "Location invalid"
        }
    }

    fileprivate var coordinatesDescription: String? {
        coordinateFormatter.formatStyle = settings.coordinatesFormat
        if let coordinate = location?.coordinate {
            return coordinateFormatter.string(from: coordinate)
        }
        return nil
    }

    @IBAction func changeAltitudeUnit() {
        if settings.distanceUnit == .meters {
            settings.distanceUnit = .feet
        } else {
            settings.distanceUnit = .meters
        }
        updateUI()
    }

    @IBAction func share(_ sender: AnyObject) {
        if location != nil {
            let activityItems = [CoordinateFormatter().string(from: location!.coordinate)]
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityViewController.title = "Share my location"
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

}

extension UINavigationController {

    // Set status to light content for dark backgrounds
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}
