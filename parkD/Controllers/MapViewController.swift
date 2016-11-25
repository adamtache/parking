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
    let mapToZone   = "mapToZone"
    
    //MARK: Other Variables
    var zonesDict = [String:ParkingZone]()
    var user: User!
    var userController: UserController!
    var locationManager: CLLocationManager!
    var zones: ParkingZoneLoader!
    var zoneTapped: ParkingZone?
    
    //MARK: Outlets
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBAction func unwindFromZoneViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSetup()
    }
    
    func mapSetup() {
        //Basic map setup code
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        //Default camera origin if user doesn't give location access
        let location = locationManager.location
        if (CLLocationManager.authorizationStatus() == .denied || location == nil) {
            mapView.camera = GMSCameraPosition.camera(withLatitude: dukeLat, longitude: dukeLong, zoom: 16)
        } else {
            mapView.camera = GMSCameraPosition(target:(location?.coordinate)!, zoom:15,bearing:0, viewingAngle:0)
        }
        
        //Setting the zones in the array into a dictionary for easy reference
        addZonesToDict(zones: zones.getDefaults())
        
        //Drawing the zones on the map
        addZoneOverlays()
        print("map view loaded")
    }

    func addZoneOverlays() {
        //Add drawn zones on map
        createZoneOverlay(zones: zones.getDefaults())
        //Add markers for each zone
        createZoneMarkers(zones: zones.getDefaults())
    }
    
    func addZonesToDict(zones: [ParkingZone]) {
        for zone in zones {
            zonesDict[zone.name] = zone
        }
    }
    
    func createZoneOverlay(zones: [ParkingZone]) {
        for zone in zones {
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
    }
    
    func createZoneMarkers(zones: [ParkingZone]) {
        for zone in zones {
            let coordinates = zone.markerPosition
            let position = CLLocationCoordinate2DMake((coordinates?.lat)!, (coordinates?.long)!)
            let marker = GMSMarker(position: position)
            marker.title = zone.name
            marker.map = mapView
        }
    }
    
    //Setting location manager, user and zone loader so it's the same as with the list view
    func setLocationManager(userController: UserController) {
        self.userController = userController
        self.locationManager = userController.locationManager
        self.zones = userController.zoneLoader
        print("location manager and parking zone loader set for the map")
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    //GMSMapViewDelegate methods
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("you tapped a lot")
        let tapped = overlay as! GMSPolygon
        zoneTapped = zonesDict[tapped.title!]
        performSegue(withIdentifier: mapToZone, sender: self)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("the location button was tapped")
        if (CLLocationManager.authorizationStatus() == .denied) {
            //TODO: Add either an alert or link to settings to change locaiton permission
            print("asking again to use location")
        }
        return false
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == mapToZone) {
            let navController = segue.destination as! UINavigationController
            let zoneVC = navController.topViewController as! ZoneViewController
            zoneVC.zone = zoneTapped
        }
    }
}
