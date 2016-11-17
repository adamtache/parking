//
//  MapViewController.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class MapViewController: UIViewController {
    
    var items: [ParkingZone] = []
    var user: User!
    var locationController : LocationController?
    
    static func instantiate() -> MapViewController {
        let storyboad = UIStoryboard(name: "MapViewController", bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        return controller
    }
    
    func setLocationManager(locationController: LocationController) {
        self.locationController = locationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }

}
