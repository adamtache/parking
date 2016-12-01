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
    
    let mapIdentifier = "MapViewController"
    let listIdentifier = "ParkingListTableViewController"
    let profileIdentifier = "ProfileViewController"
    let mainIdentifier = "Main"
    let profileTitle = "Profile"
    let mapTitle = "Map"
    let listTitle = "List"
    
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
        let mapController = self.getMapController(nav: nav1)
        
        let nav2 = UINavigationController()
        let listController = self.getListController(nav: nav2)
        
        let nav3 = UINavigationController()
        self.setupProfileController(nav: nav3)
        
        setupZones(listController: listController, mapController: mapController)
        
        let controllers = [nav1, nav2, nav3]
        self.viewControllers = controllers
    }
    
    private func getMapController(nav: UINavigationController) -> MapViewController {
        let mapController = UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: mapIdentifier) as! MapViewController
        mapController.title = mapTitle
        mapController.setLocationManager(userController: userController)
        if(self.user != nil){
            mapController.setUser(user: self.user!)
        }
        nav.title = mapTitle
        nav.viewControllers = [mapController]
        return mapController
    }
    
    private func getListController(nav: UINavigationController) -> ParkingListTableViewController {
        let listController = UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: listIdentifier) as! ParkingListTableViewController
        listController.title = listTitle
        if(self.user != nil){
            listController.setUser(user: self.user!)
        }
        nav.title = listTitle
        listController.setLocationManager(userController: userController)
        nav.viewControllers = [listController]
        return listController
    }
    
    private func setupProfileController(nav: UINavigationController) {
        let profileController = UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: profileIdentifier) as! ProfileViewController
        profileController.title = profileTitle
        if(self.user != nil){
            profileController.setUser(user: self.user!)
        }
        nav.title = profileTitle
        nav.viewControllers = [profileController]
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
