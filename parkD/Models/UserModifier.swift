//
//  UserModifier.swift
//  parkD
//
//  Created by Adam on 11/17/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class UserModifier{
    
    // MARK: Constants
    let userRef = FIRDatabase.database().reference(withPath: "user-info")
    let abbrRef = FIRDatabase.database().reference(withPath: "abbr")
    
    init() {
    }
    
    func changePass(email: String, newPass: String) {
        let user = FIRAuth.auth()?.currentUser
        user?.updatePassword(newPass)
    }
    
    func changePermit(email: String, newPermit: String) {
        let user = FIRAuth.auth()?.currentUser
        userRef.child((user?.email?.replacingOccurrences(of: ".", with: ","))!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            let permit = value?["permit"] as? String
            let abbr = value?["abbr"] as! String
            var oldUser = self.createUser(email: email, permit: permit!, abbr: abbr)
            let localUserRef = self.userRef.child((user?.email?.replacingOccurrences(of: ".", with: ","))!)
            oldUser.permit = newPermit
            self.abbrRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: AnyObject]
                let abbr = value?[newPermit] as! String
                oldUser.abbr = abbr
                localUserRef.setValue(oldUser.toAnyObject())
            }) { (error) in
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func createUser(email: String, permit: String, abbr: String) -> UserPermitInfo{
        return UserPermitInfo(email: email, permit: permit, abbr: abbr)
    }
    
}
