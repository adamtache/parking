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
    
    func getDistanceAway(locationHandler: LocationHandler, zone: ParkingZone) -> Double {
        let zoneLoc = self.getZoneLocation(zone: zone)
        let distance = self.getDistanceFromCurrLoc(location: zoneLoc, locationHandler: locationHandler)
        return Double(String(format: "%.2f", ceil(distance*100)/100))!
    }
    
    func getDistanceString(locationHandler: LocationHandler, zone: ParkingZone) -> String {
        let rounded = getDistanceAway(locationHandler: locationHandler, zone: zone)
        var distanceText = ""
        if(rounded<1.0){
            let feet = rounded*5280
            distanceText = "\(feet) feet"
        }
        else{
            distanceText = "\(rounded) mi."
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
