//
//  DistanceCalculator.swift
//  parkD
//
//  Created by Adam on 12/2/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import CoreLocation

class DistanceCalculator {
    
    let feetInMile : Double = 5280.0
    
    static func getDistanceString(userController: UserController, zone: ParkingZone) -> String {
        let distance = UserController.calcDistance(loc1: CLLocation(latitude: zone.markerLat, longitude: zone.markerLong), loc2: userController.getCurrLocation())
        let rounded = Double(String(format: "%.2f", ceil(distance*100)/100))
        var distanceText = ""
        if(rounded! < 1.0){
            let feet = rounded!*5280
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
    
}
