//
//  ParkingListTableViewController.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ParkingListTableViewController: UITableViewController, UISearchBarDelegate{
    
    //MARK: Constants
    let listToZone = "zoneCellToZoneInfo"
    
    // MARK: Vars
    var items: [ParkingZone] = []
    var searchActive : Bool = false
    var filtered = [ParkingZone]()
    var userController : UserController?
    var user: User?
    var current: ParkingZone?
    var lastSelected = 0
    
    // MARK: Outlets
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: Actions
    @IBAction func unwindFromZoneViewController(segue: UIStoryboardSegue) {
        
    }
    
    func setLocationManager(userController: UserController) {
        self.userController = userController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingTableViewCell", for: indexPath) as! ParkingTableViewCell
        let zone : ParkingZone
        zone = searchActive ? filtered[(indexPath as NSIndexPath).row] : items[(indexPath as NSIndexPath).row]
        cell.zone = zone
        cell.nameLabel.text = zone.name
        cell.photoView.image = zone.image
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = items.filter({ (item) -> Bool in
            let tmp: NSString = item.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == listToZone) {
            let selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
            let navController = segue.destination as! UINavigationController
            let zoneVC = navController.topViewController as! ZoneViewController
            zoneVC.zone = self.items[(selectedIndex?.row)!]
        }
    }
    
}
