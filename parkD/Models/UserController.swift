//
//  LocationController.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import CoreLocation

class UserController: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var lastLocation : CLLocation?
    var user: User?
    var zoneLoader = ParkingZoneLoader()
    var passLoader = ParkingPassLoader()
    
    override init(){
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10.0
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
//        if let location = locations.first {
//                        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//                        locationController!.locationManager.stopUpdatingLocation()
//                    }
        lastLocation = locations.last! as CLLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                switch status {
                case .authorizedWhenInUse:
                    print("Location AuthorizedWhenInUse")
                    locationManager.startUpdatingLocation()
                default: break
                }
        
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
