//
//  LocationController.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var lastLocation : CLLocation?
    
    // MARK: Constants
    let dukeLat     = 36.0014258
    let dukeLong    = -78.9382286
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            lastLocation = locationManager.location
        } else {
            lastLocation = CLLocation(latitude: dukeLat, longitude: dukeLong)

        }

        locationManager.distanceFilter = 10.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            //No additional code needed currently, but the func needs to remain
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func getCurrLocation() -> CLLocation{
        return lastLocation!
    }
    
    static func calcDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        return loc1.distance(from: loc2)/1609.344
    }
    
}
