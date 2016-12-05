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
    
    // MARK: Constants
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    let tagCellIdentifier = "TagTableViewCell"
    
    // MARK: Variables
    var zone : ParkingZone?
    var items : [Tag] = []
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: tagCellIdentifier, for: indexPath) as! TagTableViewCell
        let tag : Tag
        tag = items[(indexPath as NSIndexPath).row]
        cell.cellTag = tag
        cell.agreeCountLabel.text = "\(tag.agreeScore)"
        cell.disagreeCountLabel.text = "\(tag.disagreeScore)"
        cell.nameLabel.text = "\(tag.name)"
        return cell
    }
    
    func refresh() {
        getPermitTypes()
    }
    
    func setZone(zone: ParkingZone) {
        self.zone = zone
        getPermitTypes()
    }
    
    //Get the tags from Firebase
    private func getPermitTypes() {
        tagRef.child((zone?.name)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                // Get user value
                let value = rest.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let agreeScore = value?["agreeScore"] as! Int
                let disagreeScore = value?["disagreeScore"] as! Int
                self.items.append(self.getTag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore))
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getTag(name: String, agreeScore: Int, disagreeScore: Int) -> Tag {
        return Tag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore)
    }
    
}
