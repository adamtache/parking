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
    
    func load() {
        setDefaults()
    }
    
    func setDefaults() {
        let blueZone = getBlueZone()
        let blueZoneRef = zoneRef.child(blueZone.name)
        blueZoneRef.setValue(blueZone.toAnyObject())
    }
    
    private func getBlueZone() -> ParkingZone {
        let name = "Blue"
        let addedByUser = "Admin"
        let capacity = 1000
        let overlayColor = UIColor.blue
        let markerLat = 35.997452
        let markerLong = -78.939005
        let image = UIImage(named: "defaultPhoto")!
        var coordinates = [Double:Double]()
        //Create coordinate layouts for the zone
        coordinates[35.997452] = -78.939005
        coordinates[35.99743] = -78.938479
        coordinates[35.99648] = -78.938082
        coordinates[35.996124] = -78.938028
        coordinates[35.995846] = -78.938334
        coordinates[35.994943] = -78.93835
        coordinates[35.994262] = -78.937422
        coordinates[35.993654] = -78.938693
        coordinates[35.993963] = -78.938752
        coordinates[35.99391] = -78.940442
        coordinates[35.995538] = -78.940147
        coordinates[35.996163] = -78.940212
        coordinates[35.996502] = -78.939047
        coordinates[35.997448] = -78.939106
        coordinates[35.997452] = -78.939005

//        return ParkingZone(name: name, addedByUser: addedByUser, key: "", capacity: capacity, coordinates: coordinates, overlayColor: overlayColor, markerLat: markerLat, markerLong: markerLong, image: image)
        return ParkingZone(name: name, addedByUser: addedByUser, key: "", capacity: capacity,overlayColor: overlayColor, markerLat: markerLat, markerLong: markerLong, image: image)
    }
    
}
