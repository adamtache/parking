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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        lastLocation = locations.last! as CLLocation
    }
    
    func getCurrLocation() -> CLLocation{
        return lastLocation!
    }
    
    static func calcDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        let coord1 = loc1.coordinate
        let coord2 = loc2.coordinate
        let d1 = pow(coord1.latitude - coord2.latitude, 2)
        let d2 = pow(coord1.longitude - coord2.longitude, 2)
        return sqrt(d1 + d2)
    }
    
}
