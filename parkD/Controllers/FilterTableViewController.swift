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
    let items : [String] = ["Valid Permit", "Open Now", "Closest Distance"]
    var switches : [String: Bool] = [String: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setDefaultSwitches()
        
        self.tableView.reloadData()
    }
    
    private func setDefaultSwitches() {
        switches["Valid Permit"] = false
        switches["Open Now"] = false
        switches["Closest Distance"] = true
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
        cell.cellSwitch.setOn(switches[name]!, animated: false)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func changeStateTo(isOn: Bool, row: Int) {
        switches["\(row)"] = isOn
    }

}
