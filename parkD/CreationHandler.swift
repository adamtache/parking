//
//  CreationHandler.swift
//  parkD
//
//  Created by Adam on 12/4/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class CreationHandler {
    
    func getZone(name: String, addedByUser: String, capacity: Int, percentFull: Double, markerLat: Double, markerLong: Double)-> ParkingZone {
        let overlayColor = UIColor.blue
        let image = UIImage(named: "defaultPhoto")!
        return ParkingZone(name: name, addedByUser: addedByUser, key: "", capacity: capacity, percentFull: Double(percentFull), overlayColor: overlayColor, markerLat: markerLat, markerLong: markerLong, image: image)
    }
    
}
