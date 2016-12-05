//
//  DistanceCalculator.swift
//  parkD
//
//  Created by Adam on 12/2/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import CoreLocation

class DistanceHandler {
    
    let feetInMile : Double = 5280.0
    
    func getDistanceAway(source: CLLocation, destination: ParkingZone) -> Double {
        let zoneLoc = self.getZoneLocation(zone: destination)
        let distance = LocationHandler.calcDistance(loc1: zoneLoc, loc2: source)
        return Double(String(format: "%.2f", ceil(distance*100)/100))!
    }
    
    func getDistanceString(source: CLLocation, zone: ParkingZone) -> String {
        let rounded = getDistanceAway(source: source, destination: zone)
        return self.getDistanceString(distance: rounded)
    }
    
    func getDistanceString(distance: Double) -> String {
        var distanceText = ""
        if(distance<1.0){
            let feet = distance*5280
            distanceText = "\(feet) feet"
        }
        else{
            distanceText = "\(distance) mi."
        }
        return distanceText
    }
    
    func milesToFeet(number: Double) -> Double {
        return feetInMile*number
    }
    
    private func getZoneLocation(zone: ParkingZone) -> CLLocation {
        return CLLocation(latitude: zone.markerLat, longitude: zone.markerLong)
    }
    
    private func getDistanceFromCurrLoc(location: CLLocation, locationHandler: LocationHandler) -> Double {
        return LocationHandler.calcDistance(loc1: location, loc2: locationHandler.getCurrLocation())
    }
    
}
