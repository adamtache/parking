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
            return false
        }
        if(!signIn(email: email, pass: pass)){
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
        FIRAuth.auth()!.createUser(withEmail: email,
                                   password: pass) { user, error in
                                    if error == nil {
                                        FIRAuth.auth()!.signIn(withEmail: email,
                                                               password: pass)
                                    }
                                    else{
                                        print("signup error")
                                    }
        }
        print("adding user with permit to DB")
        addUserWithPermitToDB(email: email, permit: permit)
        return true
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
        FIRAuth.auth()?.signIn(withEmail: email, password: pass) { (user, error) in
            
        }
        print("signed in")
        return true
    }

}
