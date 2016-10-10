//
//  SettingsTableViewController.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 10/2/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    private struct Keys {
        static let coordinatesFormat = "coordinatesFormat"
        static let unit = "unit"
    }

    @IBOutlet var coordinatesSelectionCells: [UITableViewCell]!

    private var selectedCoordinateFormatRow: Int? {
        didSet {
            if oldValue != nil {
                coordinatesSelectionCells[oldValue!].accessoryType = .None
            }
            if selectedCoordinateFormatRow != nil {
                coordinatesSelectionCells[selectedCoordinateFormatRow!].accessoryType = .Checkmark
                NSUserDefaults.standardUserDefaults().setInteger(selectedCoordinateFormatRow!, forKey: Keys.coordinatesFormat)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCoordinateFormatRow = NSUserDefaults.standardUserDefaults().integerForKey(Keys.coordinatesFormat)
    }


    @IBOutlet weak var unitSegmentedControl: UISegmentedControl! {
        didSet {
            if let unitName = NSUserDefaults.standardUserDefaults().stringForKey(Keys.unit) {
                if unitName == "meters" {
                    unitSegmentedControl.selectedSegmentIndex = 0
                } else if unitName == "feet" {
                    unitSegmentedControl.selectedSegmentIndex = 1
                }
            }
        }
    }

    @IBAction func changeUnit(sender: UISegmentedControl) {
        let unitName = (sender.selectedSegmentIndex == 0) ? "meters" : "feet"
        NSUserDefaults.standardUserDefaults().setObject(unitName, forKey: Keys.unit)
    }

    // MARK: Table View Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            selectedCoordinateFormatRow = indexPath.row
        }

    }
}
