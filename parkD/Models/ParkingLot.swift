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

struct ParkingLot {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var full: Bool
    var comments: [String]
    var capacity: Int
    
    init(name: String, addedByUser: String, full: Bool, key: String = "", comments: [String], capacity: Int){
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.full = full
        self.ref = nil
        self.comments = comments
        self.capacity = capacity
    }
    
    init(snapshot: FIRDataSnapshot){
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
            "name": name,
            "addedByUser": addedByUser,
            "full": full,
            "comments": comments,
            "capacity": capacity
        ]
    }
    
}
