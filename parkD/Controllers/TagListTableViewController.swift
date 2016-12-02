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
        
        self.tableView.reloadData()
        
        getPermitTypes()
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
        cell.agreeCountLabel.text = "\(tag.agreeScore)"
        cell.disagreeCountLabel.text = "\(tag.disagreeScore)"
        cell.nameLabel.text = "\(tag.name)"
        return cell
    }
    
    //Get the tags from Firebase
    private func getPermitTypes() {
        TagLoader().setDefaults()
        for name in tagNames {
            tagRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let agreeScore = value?["agreeScore"] as! Int
                let disagreeScore = value?["disagreeScore"] as! Int
                self.items.append(self.getTag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore))
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func getTag(name: String, agreeScore: Int, disagreeScore: Int) -> Tag {
        return Tag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore)
    }
    
}
