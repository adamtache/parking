//
//  ParkingListTableViewController.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class TagListTableViewController: UITableViewController {
    
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    
    var tagNames : [String] = ["Space Available", "Full", "Ticketing", "Towing", "Blocked"]
    
    var items : [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        items = loadItems()!
        self.tableView.reloadData()
    }
    
    private func loadItems() -> [Tag]? {
        return TagLoader().getItems()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
        let tag : Tag
        tag = items[(indexPath as NSIndexPath).row]
        cell.cellTag = tag
        if (tag == nil) {
            return cell
        }
        cell.agreeCountLabel.text = "\(tag.agreeScore)"
        cell.disagreeCountLabel.text = "\(tag.disagreeScore)"
        cell.nameLabel.text = "\(tag.name)"
        return cell
    }
    
}
