//
//  ParkingListTableViewController.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class TagListTableViewController: UITableViewController, TagVoteChanged {
    
    // MARK: Constants
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    let tagCellIdentifier = "TagTableViewCell"
    let accurateVotersRef = FIRDatabase.database().reference(withPath: "accurateVoters")
    let notAccurateVotersRef = FIRDatabase.database().reference(withPath: "notAccurateVoters")
    
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
        var tag : Tag = items[(indexPath as NSIndexPath).row]
        tag.delegate = self
        cell.cellTag = tag
        tag.zoneName = (zone?.name)!
        cell.agreeCountLabel.text = "\(getAccurateScore(accurateAgreeScore: tag.accurateAgreeScore, accurateDisagreeScore: tag.accurateDisagreeScore))"
        cell.disagreeCountLabel.text = "\(getNotAccurateScore(notAccurateAgreeScore: tag.notAccurateAgreeScore, notAccurateDisagreeScore: tag.notAccurateDisagreeScore))"
        cell.nameLabel.text = "\(tag.name)"
        return cell
    }
    
    func changedState(){
        self.refresh()
    }
    
    func refresh() {
        self.items = []
        loadTags()
        self.tableView.reloadData()
    }
    
    func setZone(zone: ParkingZone) {
        self.zone = zone
        loadTags()
    }
    
    //Get the tags from Firebase
    private func loadTags() {
        let zoneName = (zone?.name)!
        tagRef.child(zoneName).observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                // Get user value
                let value = rest.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let accurateAgreeScore = value?["accurateAgreeScore"] as! Int
                let accurateDisagreeScore = value?["accurateDisagreeScore"] as! Int
                let notAccurateAgreeScore = value?["notAccurateAgreeScore"] as! Int
                let notAccurateDisagreeScore = value?["notAccurateDisagreeScore"] as! Int
                let zoneName = value?["zoneName"] as! String
                
                self.accurateVotersRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value2 = snapshot.value as? [String: AnyObject]
                    let accurateVoters = value2?[zoneName] as! NSDictionary
                    self.notAccurateVotersRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value3 = snapshot.value as? [String: AnyObject]
                        let notAccurateVoters = value3?[zoneName] as! NSDictionary
                        self.items.append(self.getTag(name: name, accurateAgreeScore: accurateAgreeScore, accurateDisagreeScore: accurateDisagreeScore, notAccurateAgreeScore: notAccurateAgreeScore, notAccurateDisagreeScore: notAccurateDisagreeScore, zoneName: zoneName, accurateVoters: accurateVoters as! [String : String], notAccurateVoters: notAccurateVoters as! [String : String]))
                        self.tableView.reloadData()
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getAccurateScore(accurateAgreeScore: Int, accurateDisagreeScore: Int) -> Int {
        return abs(accurateAgreeScore) - abs(accurateDisagreeScore)
    }
    
    private func getNotAccurateScore(notAccurateAgreeScore: Int, notAccurateDisagreeScore: Int) -> Int {
        return abs(notAccurateAgreeScore) - abs(notAccurateDisagreeScore)
    }
    
    private func getTag(name: String, accurateAgreeScore: Int, accurateDisagreeScore: Int, notAccurateAgreeScore: Int, notAccurateDisagreeScore: Int, zoneName: String, accurateVoters: [String: String], notAccurateVoters: [String: String]) -> Tag {
        return Tag(name: name, accurateAgreeScore: accurateAgreeScore, accurateDisagreeScore: accurateDisagreeScore, notAccurateAgreeScore: notAccurateAgreeScore, notAccurateDisagreeScore: notAccurateDisagreeScore, zoneName: zoneName, accurateVoters: accurateVoters, notAccurateVoters: notAccurateVoters)
    }
    
}
