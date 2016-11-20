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
    
    //MARK: Typealiases
    typealias polycoordinates = (lat: Double, long: Double)
    
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
    var userController: UserController!
    var locationManager: CLLocationManager!
    var zones = ParkingZoneLoader()
    
    //MARK: Outlets
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map view loaded")
        mapSetup()
        tempSetup()
    }
    
    func mapSetup() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }
    
    func tempSetup() {
        let camera = GMSCameraPosition.camera(withLatitude: dukeLat, longitude: dukeLong, zoom: 16)
        mapView.camera = camera
        createZoneOverlay(zone: zones.getBlueZone())
    }
    
    func createZoneOverlay(zone: ParkingZone) {
        let coordinates = zone.polycoordinates
        let path = GMSMutablePath()
        for (lat, long) in coordinates! {
            path.add(CLLocationCoordinate2D(latitude: lat, longitude: long))
        }
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = zone.overlayColor
        polygon.title = zone.name
        polygon.isTappable = true
        polygon.map = mapView
    }
    
    func setLocationManager(userController: UserController) {
        self.userController = userController
        locationManager = userController.locationManager
        print("map setting up")
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    //GMSMapViewDelegate methods
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("you tapped the miracle lot")
    }
}
