//
//  LocationController.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var lastLocation : CLLocation?
    
    override init(){
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10.0
    }
    
}
