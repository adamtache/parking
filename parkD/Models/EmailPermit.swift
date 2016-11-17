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

struct EmailPermit {
    
    let email: String
    let permit: String
    let ref: FIRDatabaseReference?
    let key: String
    
    init(email: String, permit: String) {
        self.email = email
        self.permit = permit
        self.key = ""
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        
        // Initializes through Firebase data called 'FIRDataSnapshot'.
        
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        permit = snapshotValue["permit"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            
            // Creates data to be stored into Firebase database.
            
            "email": email,
            "permit": permit
        ]
    }
    
}
