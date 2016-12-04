//
//  UserVerifier.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class UserVerifier {
    
    // MARK: Constants
    let userRef = FIRDatabase.database().reference(withPath: "user-info")
    let permitTransferRef = FIRDatabase.database().reference(withPath: "permit-transfer")
    
    init() {
    }
    
    func checkEmail(email: String) -> Bool{
        // Checks for valid email via regex.
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkPass(pass: String) -> Bool{
        // Checks for valid password via regex.
        let passRegEx = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passTest.evaluate(with: pass)
    }

    func signOut() {
        try! FIRAuth.auth()!.signOut()
    }
    
    func addUserWithPermitToDB(email: String, permit: String, abbr: String){
        let user = createUser(email: email, permit: permit, abbr: abbr)
        let localUserRef = userRef.child(user.email.replacingOccurrences(of: ".", with: ","))
        localUserRef.setValue(user.toAnyObject())
    }
    
    private func createUser(email: String, permit: String, abbr: String) -> UserPermitInfo{
        return UserPermitInfo(email: email, permit: permit, abbr: abbr)
    }

}
