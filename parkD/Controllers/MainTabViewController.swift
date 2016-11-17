//
//  MainTabViewController.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import CoreLocation

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var locationController : LocationController = LocationController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("main tab loaded")
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("setting up controllers")
        
        let nav1 = UINavigationController()
        let item1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        item1.title = "Map"
        item1.setLocationManager(locationController: locationController)
        nav1.title = "Map"
        nav1.viewControllers = [item1]
        
        let nav2 = UINavigationController()
        let item2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParkingListTableViewController") as! ParkingListTableViewController
        item2.title = "List"
        nav2.title = "List"
        item2.setLocationManager(locationController: locationController)
        nav2.viewControllers = [item2]
        
        let nav3 = UINavigationController()
        let item3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        item3.title = "Profile"
        nav3.title = "Profile"
        nav3.viewControllers = [item3]
        
        let controllers = [nav1, nav2, nav3]
        self.viewControllers = controllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationController.lastLocation = locations.last!
    }

}
