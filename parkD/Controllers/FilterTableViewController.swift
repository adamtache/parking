//
//  FilterTableViewController.swift
//  parkD
//
//  Created by Adam on 12/1/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    // MARK: Constants
    let cellIdentifier = "FilterTableViewCell"
    let items : [String] = ["Valid Permit", "Open Now", "Closest Distance"]
    
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
        cell.cellLabel.text = name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
