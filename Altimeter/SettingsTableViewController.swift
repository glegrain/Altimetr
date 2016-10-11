//
//  SettingsTableViewController.swift
//  Altimeter
//
//  Created by Guillaume Legrain on 10/2/16.
//  Copyright © 2016 Guillaume Legrain. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    fileprivate struct Keys {
        static let coordinatesFormat = "coordinatesFormat"
        static let unit = "unit"
    }

    @IBOutlet var coordinatesSelectionCells: [UITableViewCell]!

    fileprivate var selectedCoordinateFormatRow: Int? {
        didSet {
            if oldValue != nil {
                coordinatesSelectionCells[oldValue!].accessoryType = .none
            }
            if selectedCoordinateFormatRow != nil {
                coordinatesSelectionCells[selectedCoordinateFormatRow!].accessoryType = .checkmark
                UserDefaults.standard.set(selectedCoordinateFormatRow!, forKey: Keys.coordinatesFormat)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCoordinateFormatRow = UserDefaults.standard.integer(forKey: Keys.coordinatesFormat)
    }


    @IBOutlet weak var unitSegmentedControl: UISegmentedControl! {
        didSet {
            if let unitName = UserDefaults.standard.string(forKey: Keys.unit) {
                if unitName == "meters" {
                    unitSegmentedControl.selectedSegmentIndex = 0
                } else if unitName == "feet" {
                    unitSegmentedControl.selectedSegmentIndex = 1
                }
            }
        }
    }

    @IBAction func changeUnit(_ sender: UISegmentedControl) {
        let unitName = (sender.selectedSegmentIndex == 0) ? "meters" : "feet"
        UserDefaults.standard.set(unitName, forKey: Keys.unit)
    }

    // MARK: Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            selectedCoordinateFormatRow = (indexPath as NSIndexPath).row
        }

    }
}
