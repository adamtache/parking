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
import MapKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: Constants
    let dukeLat     = 36.0014258
    let dukeLong    = -78.9382286
    
    //MARK: Variables for Google Maps
    //var myCamera = GMSCameraPosition()
    var myMarker = GMSMarker()
    var didFindMyLocation = false
    
    //MARK: Other Variables
    var items: [ParkingZone] = []
    var user: User!
    var locationController : LocationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map view loaded")
        // Create a GMSCameraPosition that tells the map to display the coordinate given
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
    func setLocationManager(locationController: LocationController) {
        self.locationController = locationController
//        mapSetup()
        print("map setting up")
    }
    
    //MARK: Outlets
    @IBOutlet var mapView: MKMapView!
    
    func mapSetup() {
//        locationController!.locationManager.delegate = self
//        mapView.delegate = self
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    //Change authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse:
//            print("Location AuthorizedWhenInUse")
//            mapView.isMyLocationEnabled = true
//            locationController!.locationManager.startUpdatingLocation()
//        default:
//            mapView.camera = GMSCameraPosition.camera(withLatitude: dukeLat, longitude: dukeLong, zoom: 13.0)
//        }
        
    }
    
    //Update current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//            locationController!.locationManager.stopUpdatingLocation()
//        }
    }
}
