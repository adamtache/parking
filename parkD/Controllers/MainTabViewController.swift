//
//  MainTabViewController.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import CoreLocation

class MainTabViewController: UITabBarController {
    
    var locationController : LocationController = LocationController()
    
    static func instantiate() -> UITabBarController {
        let storyboad = UIStoryboard(name: "MainTabViewController", bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: "MainTabViewController") as! MainTabViewController
        controller.setupControllers()
        return controller
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    private func setupControllers() {
        let item1 = MapViewController()
        print(item1)
        print(locationManager)
        item1.setLocationManager(locationController: locationController)
        let item2 = ParkingListTableViewController()
        item2.setLocationManager(locationController: locationController)
        let item3 = ProfileViewController()
        let controllers = [item1, item2, item3]
        self.viewControllers = controllers
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationController.lastLocation = locations.last!
    }

}
