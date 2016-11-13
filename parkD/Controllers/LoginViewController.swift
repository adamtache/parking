//
//  LoginViewController.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"

    // MARK: Outlets
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var alertView: UITextView!

    

    
    // MARK: Actions
    @IBAction func loginClick(_ sender: Any) {
        if(checkFields()){
            signIn(email: getEmail(), pass: getPassword())
        }
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
    }
    
    @IBAction func signupClick(_ sender: Any) {
        if(checkFields()){
            // Create user with email and password from textfields.
            let email = getEmail()
            let pass = getPassword()
            FIRAuth.auth()!.createUser(withEmail: email, password: pass) {
                user, error in
                if error == nil {
                    // User account already exists. Sign in instead.
                    self.signIn(email: email, pass: pass)
                }
            }
        }
    }

    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue){
        //if(sender as!)
        if(segue.identifier == "signUpSuccess"){
            performSegue(withIdentifier: "LoginToList", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        securePasswordField()
        
        // Create authentication observer.
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // Test value of user.
            if user != nil {
                // Login validated. Perform segue to main screen.
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    private func securePasswordField() {
        passText.isSecureTextEntry = true
    }
    
    private func signIn(email: String, pass: String) {
        FIRAuth.auth()!.signIn(withEmail: email, password: pass)
    }
    
    private func checkFields() -> Bool{
        if(!checkEmail(email: getEmail())){
            displayInvalidEmail()
            return false
        }
        if(!checkPass(pass: getPassword())){
            displayInvalidPass()
            return false
        }
        displayValidLogin()
        return true
    }
    
    private func checkEmail(email: String) -> Bool{
        // Checks for valid email via regex.
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func checkPass(pass: String) -> Bool{
        // Checks for valid password via regex.
        let passRegEx = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passTest.evaluate(with: pass)
    }
    
    private func getEmail() -> String{
        // Returns user input
        return emailText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    private func getPassword() -> String{
        return passText.text!
    }
    
    private func displayInvalidEmail() {
        //let emailMessage = "Sorry, your email address is not valid."
        //alertView.text = emailMessage
        let controller = UIAlertController(title: "Invalid Email", message: "Sorry, your email address is not valid.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func displayInvalidPass() {
        let passMessage = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
        alertView.text = passMessage
        let controller = UIAlertController(title: "Invalid Password", message: "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func displayValidLogin() {
        //let loginMessage = "Login successful."
        //alertView.text = loginMessage
    }
    
    
}
