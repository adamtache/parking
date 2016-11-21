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

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var userController : UserController = UserController()
    var user: User?
    
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
        
        let controllers = [nav1, nav2, nav3]
        self.viewControllers = controllers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        userController.lastLocation = locations.last!
    }

}
