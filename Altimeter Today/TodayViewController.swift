//
//  TodayViewController.swift
//  Altimeter Today
//
//  Created by Guillaume Legrain on 9/16/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
        
    @IBOutlet weak var altitudeLabel: UILabel!
    
    fileprivate var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        altitudeLabel.text = "No data"
        // TODO: add accuracy bar on the right to the view
        // TODO: Open Altimeter app when touched (provide UI feedback)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request Authorization when the app is in the foreground
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // TODO: user should be able to change this
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let altitude = locations.last?.altitude {
            let numberFormatter = NumberFormatter()
            altitudeLabel.text = numberFormatter.string(from: NSNumber(value: altitude))! + " m"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        altitudeLabel.text = error.localizedDescription
    }
    
    
}
