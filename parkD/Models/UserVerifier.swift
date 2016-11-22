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
 
    init() {
    }
    
    func checkLogin(email: String, pass: String) -> Bool {
        if(!checkEmail(email: email) || !checkPass(pass: pass)){
            print("email or pass failed")
            return false
        }
        if(!signIn(email: email, pass: pass)){
            print("sign in failed")
            return false
        }
        return true
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
    
    func checkSignup(email: String, pass: String, permit: String) -> Bool {
        print("trying to signup ")
        var signedUp = true
        FIRAuth.auth()!.createUser(withEmail: email,
                                   password: pass) { user, error in
                                    if error == nil { // user created successfully
                                        print("user created successfully")
                                        self.verifyUser(email: email, pass: pass)
                                        if(!self.signIn(email: email, pass: pass)){
                                            signedUp  = false
                                        }
                                    }
                                    else{
                                        print("signup error")
                                    }
        }
        if(signedUp){
            addUserWithPermitToDB(email: email, permit: permit)
        }
        return signedUp
    }
    
    private func verifyUser(email: String, pass: String) {
        FIREmailPasswordAuthProvider.credential(withEmail: email, password: pass)
    }
    
    private func addUserWithPermitToDB(email: String, permit: String){
        let user = createUser(email: email, permit: permit)
        let localUserRef = userRef.child(user.email.replacingOccurrences(of: ".", with: ","))
        localUserRef.setValue(user.toAnyObject())
    }
    
    private func createUser(email: String, permit: String) -> EmailPermit{
        return EmailPermit(email: email, permit: permit)
    }
    
    private func signIn(email: String, pass: String) -> Bool{
        var signedIn : Bool = false
        FIRAuth.auth()?.signIn(withEmail: email, password: pass) { (user, error) in
            if(error == nil){ // successfuly signed in
                signedIn = true
            }
            else{ // sign in failed
                signedIn = false
            }
        }
        return signedIn
    }

}
