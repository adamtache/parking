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
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = 10.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //No additional code needed currently, but the func needs to remain
            print("location:: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            print("Location only when in the app")
        case .authorizedAlways:
            locationManager.requestLocation()
            print("Location always in use")
        default:
            print("No location tracking")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func getCurrLocation() -> CLLocation{
        if(lastLocation == nil){
            return CLLocation(latitude: dukeLat, longitude: dukeLong)
        }
        return lastLocation!
    }
    
    static func calcDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        return loc1.distance(from: loc2)/1609.344
    }
    
}
