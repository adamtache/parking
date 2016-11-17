//
//  ParkingLotLoader.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class ParkingZoneLoader {
    
    let zoneRef = FIRDatabase.database().reference(withPath: "parking-lots")
    
    init() {
    }
    
    func getItems() -> [ParkingZone]? {
        // TODO: Grab this from Firebase
        return getDefaults()
    }
    
    func getDefaults() -> [ParkingZone] {
        var zones : [ParkingZone] = []
        let blueZone = getBlueZone()
        let blueZoneRef = zoneRef.child(blueZone.name)
        blueZoneRef.setValue(blueZone.toAnyObject())
        zones.append(blueZone)
        return zones
    }
    
    private func getBlueZone() -> ParkingZone {
        let name = "Blue Zone"
        let addedByUser = "Admin"
        let full = false
        let comments = [""]
        let capacity = 1000
        return ParkingZone(name: name, addedByUser: addedByUser, full: full, comments: comments, capacity: capacity)
    }
    
}
