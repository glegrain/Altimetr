//
//  SettingsTableViewController.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 10/2/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    fileprivate let settings = Settings()

    @IBOutlet var coordinatesSelectionCells: [UITableViewCell]!

    fileprivate var selectedCoordinateFormatRow: Int! {
        didSet {
            if oldValue != nil {
                coordinatesSelectionCells[oldValue!].accessoryType = .none
            }
            coordinatesSelectionCells[selectedCoordinateFormatRow!].accessoryType = .checkmark
            settings.coordinatesFormat = CoordinateFormatter.NSFormattingFormatStyle(rawValue: selectedCoordinateFormatRow)!
        }
    }

    override func viewDidLoad() {
        selectedCoordinateFormatRow = self.settings.coordinatesFormat.rawValue
    }

    @IBOutlet weak var unitSegmentedControl: UISegmentedControl! {
        didSet {
            switch settings.distanceUnit {
            case UnitLength.meters:
                unitSegmentedControl.selectedSegmentIndex = 0
            case UnitLength.feet:
                unitSegmentedControl.selectedSegmentIndex = 1
            default:
                fatalError("Not implemented")
            }
        }
    }

    @IBAction func changeUnit(_ sender: UISegmentedControl) {
        settings.distanceUnit = (sender.selectedSegmentIndex == 0) ? .meters : .feet
    }

    // MARK: Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            selectedCoordinateFormatRow = (indexPath as NSIndexPath).row
        }

    }
}
