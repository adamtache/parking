//
//  User.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init() {
        self.email = "guest@guest.com"
        self.uid = "0"
    }
    
}
