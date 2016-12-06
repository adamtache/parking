//
//  ParkingListTableViewController.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import CoreLocation

class ParkingListTableViewController: UITableViewController {
    
    //MARK: Constants
    let listToZone = "zoneCellToZoneInfo"
    let cellIdentifier = "ParkingTableViewCell"
    
    // MARK: Vars
    var items: [ParkingZone] = []
    var locationHandler : LocationHandler!
    var locationManager: CLLocationManager!
    var user: User?
    
    // MARK: Actions
    @IBAction func unwindFromZoneViewController(segue: UIStoryboardSegue) {
        
    }
    
    func setLocationManager(locationHandler: LocationHandler) {
        self.locationHandler = locationHandler
        self.locationManager = locationHandler.locationManager
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ParkingTableViewCell
        let zone : ParkingZone = items[(indexPath as NSIndexPath).row]
        cell.zone = zone
        cell.nameLabel.text = zone.name
        //cell.photoView.image = zone.image
        // Reference to an image file in Firebase Storage
        let storage = FIRStorage.storage()
        let reference = storage.reference(withPath: zone.name + ".jpg")
        
        // Load the image using SDWebImage
        cell.photoView.sd_setImage(with: reference)
        cell.distanceLabel.text = DistanceHandler().getDistanceString(source: locationHandler.getCurrLocation(), zone: zone)
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
            zoneVC.locationHandler = locationHandler
            zoneVC.setZone(zone: self.items[(selectedIndex?.row)!])
        }
    }
    
}
