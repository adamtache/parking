//
//  MainTabViewController.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import FirebaseDatabase

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var userController : UserController = UserController()
    var user: User?
    
    let zoneRef = FIRDatabase.database().reference(withPath: "parking-lots")
    let zoneNames : [String] = ["Blue"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.delegate = self
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav1 = UINavigationController()
        let item1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        item1.title = "Map"
        item1.setLocationManager(userController: userController)
        if(self.user != nil){
            item1.setUser(user: self.user!)
        }
        nav1.title = "Map"
        nav1.viewControllers = [item1]
        
        let nav2 = UINavigationController()
        let item2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingListTableViewController") as! ParkingListTableViewController
        item2.title = "List"
        if(self.user != nil){
            item2.setUser(user: self.user!)
        }
        nav2.title = "List"
        item2.setLocationManager(userController: userController)
        nav2.viewControllers = [item2]
        
        let nav3 = UINavigationController()
        let item3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        item3.title = "Profile"
        if(self.user != nil){
            item3.setUser(user: self.user!)
        }
        nav3.title = "Profile"
        nav3.viewControllers = [item3]
        
        setupZones(listController: item2, mapController: item1)
        
        let controllers = [nav1, nav2, nav3]
        self.viewControllers = controllers
    }
    
    private func setupZones(listController: ParkingListTableViewController, mapController: MapViewController) {
        for name in zoneNames {
            zoneRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let addedByUser = value?["addedByUser"] as? String ?? ""
                let capacity = value?["capacity"] as! Int
                let markerLat = value?["markerLat"] as! Double
                let markerLong = value?["markerLong"] as! Double
                var zone = self.getZone(name: name, addedByUser: addedByUser, capacity: capacity, markerLat: markerLat, markerLong: markerLong)
                listController.items.append(zone)
                mapController.addZone(zone: zone)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func getZone(name: String, addedByUser: String, capacity: Int, markerLat: Double, markerLong: Double)-> ParkingZone {
        let overlayColor = UIColor.blue
        let image = UIImage(named: "defaultPhoto")!
        return ParkingZone(name: name, addedByUser: addedByUser, key: "", capacity: capacity, overlayColor: overlayColor, markerLat: markerLat, markerLong: markerLong, image: image)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        userController.lastLocation = locations.last!
    }

}
