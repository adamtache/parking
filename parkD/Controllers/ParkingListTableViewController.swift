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

class ParkingListTableViewController: UITableViewController {
    
    //MARK: Constants
    let listToZone = "zoneCellToZoneInfo"
    let cellIdentifier = "ParkingTableViewCell"
    
    // MARK: Vars
    var items: [ParkingZone] = []
    var searchActive : Bool = false
    var filtered = [ParkingZone]()
    var userController : UserController!
    var locationManager: CLLocationManager!
    var user: User?
    var current: ParkingZone?
    var lastSelected = 0
    
    // MARK: Outlets
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: Actions
    @IBAction func unwindFromZoneViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromFilter(segue: UIStoryboardSegue) {
        
    }
    
    func setLocationManager(userController: UserController) {
        self.userController = userController
        self.locationManager = userController.locationManager
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ParkingTableViewCell
        let zone : ParkingZone
        zone = searchActive ? filtered[(indexPath as NSIndexPath).row] : items[(indexPath as NSIndexPath).row]
        cell.zone = zone
        cell.nameLabel.text = zone.name
        cell.photoView.image = zone.image
        return cell
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
            if (locationManager.location?.coordinate != nil) {
                zoneVC.coordinate = locationManager.location?.coordinate
            }
        }
    }
    
}
