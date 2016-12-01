//
//  ParkingLot.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct ParkingZone {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var capacity: Int
    var percentFull: Int
    var image: UIImage!
    var overlayColor: UIColor!
    var markerLat : Double
    var markerLong : Double
//    var coordinates: [Double:Double]
    
//    init(name: String, addedByUser: String, key: String = "", capacity: Int, coordinates: [Double:Double], overlayColor: UIColor, markerLat: Double, markerLong: Double, image: UIImage){
//        
//        // Initializes parking lot through parameters.
//        
//        self.key = key
//        self.name = name
//        self.addedByUser = addedByUser
//        self.ref = nil
//        self.capacity = capacity
//        self.coordinates = coordinates
//        self.overlayColor = overlayColor
//        self.markerLat = markerLat
//        self.markerLong = markerLong
//        self.image = image
//    }
    
    init(name: String, addedByUser: String, key: String = "", capacity: Int, percentFull: Int, overlayColor: UIColor, markerLat: Double, markerLong: Double, image: UIImage){
        
        // Initializes parking lot through parameters.
        
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.ref = nil
        self.capacity = capacity
        self.percentFull = percentFull
//        self.coordinates = coordinates
        self.overlayColor = overlayColor
        self.markerLat = markerLat
        self.markerLong = markerLong
        self.image = image
    }
    
    init(snapshot: FIRDataSnapshot){
        
        // Initializes parking lot through Firebase data called 'FIRDataSnapshot'.
        
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        capacity = snapshotValue["capacity"] as! Int
        percentFull = snapshotValue["percentFull"] as! Int
//        coordinates = snapshotValue["coordinates"] as! [Double:Double]!
        markerLat = snapshotValue["markerLat"] as! Double
        markerLong = snapshotValue["markerLong"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            
            // Creates data to be stored into Firebase database.
            
            "name": name,
            "addedByUser": addedByUser,
            "capacity": capacity,
//            "coordinates": coordinates,
            "markerLat": markerLat,
            "markerLong": markerLong
        ]
    }
    
}
