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
    typealias polycoordinates = (lat: Double, long: Double)
    
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
    
    func getBlueZone() -> ParkingZone {
        let name = "Blue Zone"
        let addedByUser = "Admin"
        let full = false
        let comments = [""]
        let capacity = 1000
        let overlayColor = UIColor.blue
        var coordinates : [polycoordinates] = []
        //Create coordinate layouts for the zone
        coordinates.append( (lat: 35.997452, long: -78.939005) )
        coordinates.append( (lat: 35.99743, long: -78.938479) )
        coordinates.append( (lat: 35.99648, long: -78.938082) )
        coordinates.append( (lat: 35.996124, long: -78.938028) )
        coordinates.append( (lat: 35.995846, long: -78.938334) )
        coordinates.append( (lat: 35.994943, long: -78.93835) )
        coordinates.append( (lat: 35.994262, long: -78.937422) )
        coordinates.append( (lat: 35.993654, long: -78.938693) )
        coordinates.append( (lat: 35.993963, long: -78.938752) )
        coordinates.append( (lat: 35.99391, long: -78.940442) )
        coordinates.append( (lat: 35.995538, long: -78.940147) )
        coordinates.append( (lat: 35.996163, long: -78.940212) )
        coordinates.append( (lat: 35.996502, long: -78.939047) )
        coordinates.append( (lat: 35.997448, long: -78.939106) )
        coordinates.append( (lat: 35.997452, long: -78.939005) )

        return ParkingZone(name: name, addedByUser: addedByUser, full: full, comments: comments, capacity: capacity, polycoordinates: coordinates, overlayColor: overlayColor)
    }
    
}
