//
//  Pass.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct ParkingPass {
    
    let key: String
    let name: String
    let ref: FIRDatabaseReference?
    var number: Int64
    
    init(name: String, key: String = "", number: Int64){
        
        // Initializes pass through parameters.
        self.key = key
        self.name = name
        self.number = number
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        
        // Initializes pass through Firebase data called 'FIRDataSnapshot'.
        
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        number = Int64(snapshotValue["number"] as! Int)
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            
            // Creates data to be stored into Firebase database.
            
            "name": name,
            "number": number
        ]
    }
    
}
