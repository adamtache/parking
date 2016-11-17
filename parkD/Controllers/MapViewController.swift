//
//  MapViewController.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: Constants
    let dukeLat     = 36.0014258
    let dukeLong    = -78.9382286
    
    //MARK: Variables for Google Maps
    var locationManager = CLLocationManager()
    //var myCamera = GMSCameraPosition()
    var myMarker = GMSMarker()
    var didFindMyLocation = false
    
    //MARK: Other Variables
    var items: [ParkingZone] = []
    var user: User!
    
    //MARK: Outlets
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display the coordinate given
        mapSetup()
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
    func mapSetup() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        //mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.settings.myLocationButton = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    //Change authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Location AuthorizedWhenInUse")
            mapView.isMyLocationEnabled = true
            locationManager.startUpdatingLocation()
        default:
            mapView.camera = GMSCameraPosition.camera(withLatitude: dukeLat, longitude: dukeLong, zoom: 13.0)
        }
        
    }
    
    //Update current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}
