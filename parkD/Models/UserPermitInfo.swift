//
//  EmailPermits.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import FirebaseDatabase

struct UserPermitInfo {
    
    var email: String
    var permit: String
    var abbr: String
    let ref: FIRDatabaseReference?
    
    init(email: String, permit: String, abbr: String) {
        self.email = email
        self.permit = permit
        self.abbr = abbr
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        
        // Initializes through Firebase data called 'FIRDataSnapshot'.
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        permit = snapshotValue["permit"] as! String
        abbr = snapshotValue["abbr"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            
            // Creates data to be stored into Firebase database.
            
            "email": email,
            "permit": permit,
            "abbr": abbr
        ]
    }
    
}
