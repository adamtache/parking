//
//  FilterTableViewController.swift
//  parkD
//
//  Created by Adam on 12/1/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController, SwitchChangedDelegate {

    // MARK: Constants
    let cellIdentifier = "FilterTableViewCell"
    let items : [String] = ["Valid Permit", "Closest Distance"]
    let validPermit = "Valid Permit"
    let openNow = "Open Now"
    let closestDistance = "Closest Distance"
    let defaultSwitch : [String: Bool] = ["Valid Permit": false, "Closest Distance" : true]
    
    // MARK: Constants
    var switches : [String: Bool] = [String: Bool]()
    var button : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FilterTableViewCell
        let name = items[(indexPath as NSIndexPath).row]
        cell.delegate = self
        cell.row = indexPath.row
        cell.cellLabel.text = name
        if(switches[name] == nil) {
            setDefault(name: name)
        }
        cell.cellSwitch.setOn(switches[name]!, animated: false)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func changeStateTo(isOn: Bool, row: Int) {
        switches["\(row)"] = isOn
    }
    
    private func setDefault(name: String) {
        switches[name] = defaultSwitch[name] == nil ? true : defaultSwitch[name]
    }

}
