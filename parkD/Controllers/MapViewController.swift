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
    let mapToZone   = "mapToZone"
    
    //MARK: Other Variables
    var zonesDict = [String:ParkingZone]()
    var user: User!
    var locationHandler: LocationHandler!
    var locationManager: CLLocationManager!
    var zoneTapped: ParkingZone?
    
    //MARK: Outlets
    
    @IBOutlet var mapView: GMSMapView!
   
    
    @IBAction func unwindFromZoneViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        mapSetup()
    }
    
    func mapSetup() {
        //Basic map setup code
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        setupCamera()
    }
    
    func setupCamera() {
        let location = locationManager.location
        if (CLLocationManager.authorizationStatus() == .denied || location == nil) {
            mapView.camera = GMSCameraPosition.camera(withLatitude: dukeLat, longitude: dukeLong, zoom: 16)
        } else {
            mapView.camera = GMSCameraPosition(target:(location?.coordinate)!, zoom:15,bearing:0, viewingAngle:0)
        }
    }
    
    func addZone(zone: ParkingZone) {
        zonesDict[zone.name] = zone
        self.addZoneOverlay(zone: zone)
    }
    
    private func addZoneOverlay(zone: ParkingZone){
        createZoneOverlay(zone: zone)
        createZoneMarker(zone: zone)
    }
    
    private func addZonesToDict(zones: [ParkingZone]) {
        for zone in zones {
            zonesDict[zone.name] = zone
        }
    }
    
    private func createZoneOverlay(zone: ParkingZone){
//        let coordinates = zone.coordinates
        let coordinates : [Double: Double] = [:]
        let path = GMSMutablePath()
        for (lat, long) in coordinates {
            path.add(CLLocationCoordinate2D(latitude: lat, longitude: long))
        }
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = zone.overlayColor
        polygon.title = zone.name
        polygon.isTappable = true
        polygon.map = mapView
    }
    
    func createZoneOverlay(zones: [ParkingZone]) {
        for zone in zones {
            self.createZoneOverlay(zone: zone)
        }
    }
    
    func createZoneMarkers(zones: [ParkingZone]) {
        for zone in zones {
            self.createZoneMarker(zone: zone)
        }
    }
    
    private func createZoneMarker(zone: ParkingZone) {
//        let coordinates = zone.coordinates
        let coordinates : [Double: Double] = [:]
        let position = CLLocationCoordinate2DMake((zone.markerLat), (zone.markerLong))
        let marker = GMSMarker(position: position)
        marker.title = zone.name
        marker.map = mapView
    }
    
    //Setting location manager, user and zone loader so it's the same as with the list view
    func setLocationManager(locationHandler: LocationHandler) {
        self.locationHandler = locationHandler
        self.locationManager = locationHandler.locationManager
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("you tapped a marker")
        zoneTapped = zonesDict[marker.title!]
        performSegue(withIdentifier: mapToZone, sender: self)
        return true
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
