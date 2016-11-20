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
    
    typealias polycoordinates = (lat: Double, long: Double)
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var full: Bool
    var comments: [String]
    var capacity: Int
    var image: UIImage!
    var polycoordinates: [polycoordinates]!
    var overlayColor: UIColor!
    
    init(name: String, addedByUser: String, full: Bool, key: String = "", comments: [String], capacity: Int, polycoordinates: [polycoordinates], overlayColor: UIColor){
        
        // Initializes parking lot through parameters.
        
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.full = full
        self.ref = nil
        self.comments = comments
        self.capacity = capacity
        self.polycoordinates = polycoordinates
        self.overlayColor = overlayColor
    }
    
    init(snapshot: FIRDataSnapshot){
        
        // Initializes parking lot through Firebase data called 'FIRDataSnapshot'.
        
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        full = snapshotValue["full"] as! Bool
        comments = snapshotValue["comments"] as! [String]
        capacity = snapshotValue["capacity"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            
            // Creates data to be stored into Firebase database.
            
            "name": name,
            "addedByUser": addedByUser,
            "full": full,
            "comments": comments,
            "capacity": capacity
        ]
    }
    
}
