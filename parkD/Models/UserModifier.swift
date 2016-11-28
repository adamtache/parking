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
    
    init() {
    }
    
    func changePass(email: String, newPass: String) -> Bool {
        let user = FIRAuth.auth()?.currentUser
        return ((user?.updatePassword(newPass)) != nil)
    }
    
    func changeEmail(email: String, newEmail: String) {
        let user = FIRAuth.auth()!.currentUser!
        user.updateEmail(newEmail, completion: { (error) in
            if(error == nil){
                var permit : String?
                let localUserRef = self.userRef.child((email.replacingOccurrences(of: ".", with: ",")))
                localUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? [String: AnyObject]
                    permit = value?["permit"] as? String
                    if(permit == nil){
                        return
                    }
                    localUserRef.removeValue()
                    UserVerifier().addUserWithPermitToDB(email: newEmail, permit: permit!)
                }) { (error) in
                    print("user not found")
                }
            }
        })
    }
    
    func changePermit(email: String, newPermit: String) {
        let user = FIRAuth.auth()?.currentUser
        var permit : String?
        
        userRef.child((user?.email?.replacingOccurrences(of: ".", with: ","))!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            permit = value?["permit"] as? String
        }) { (error) in
            print(error.localizedDescription)
        }
        
        var oldUser = createUser(email: email, permit: permit!)
        let localUserRef = userRef.child((user?.email?.replacingOccurrences(of: ".", with: ","))!)
        oldUser.permit = newPermit
        localUserRef.setValue(oldUser.toAnyObject())
    }
    
    private func createUser(email: String, permit: String) -> EmailPermit{
        return EmailPermit(email: email, permit: permit)
    }
    
}
