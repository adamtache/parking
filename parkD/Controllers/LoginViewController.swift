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
    let signUpSuccess = "signUpSuccess"
    
    let invalidEmailTitle = "Invalid Email"
    let invalidEmailMessage = "Sorry, your email address is not valid."
    let emptyEmailMessage = "Please enter an email address."
    let invalidPasswordTitle = "Invalid Password"
    let emptyPassMessage = "Please enter a password."


    // MARK: Outlets
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    override func shouldPerformSegue(withIdentifier identifier: String,sender: Any?) -> Bool {
        if(identifier == loginToList) {
            if (checkFields()) {
                return true
            } else {
                return false
            }
        }
        return true
    }

    
    // MARK: Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == loginToList){
            print("should be going to main app")
            //signIn(email: getEmail(), pass: getPassword())
        }
    }

    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue){
        //if(sender as!)
        if(segue.identifier == signUpSuccess){
            
            performSegue(withIdentifier: loginToList, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Create authentication observer
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // Test value of user
            if user != nil {
                // Login validated; Perform segue to main screen
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func signIn(email: String, pass: String) {
        FIRAuth.auth()!.signIn(withEmail: email, password: pass)
    }
    
    private func checkFields() -> Bool{
        return checkEmail() && checkPass()
    }
    
    private func checkEmail() -> Bool{
        // Checks for valid email via regex.
        if (emailText.text?.isEmpty)! {
            displayMessage(title: invalidEmailTitle, message: emptyEmailMessage)
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = emailTest.evaluate(with: getEmail())
        if (!isValid) {
            displayMessage(title: invalidEmailTitle, message: invalidEmailMessage)
        }
        return isValid
    }
    
    private func checkPass() -> Bool{
        // Checks for valid password via regex.
        if((getPassword().isEmpty)){
            displayMessage(title: invalidPasswordTitle, message: emptyPassMessage)
            return false
        }
        return true
    }
    
    private func getEmail() -> String{
        // Returns user input
        return emailText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    private func getPassword() -> String{
        return passText.text!
    }
    
    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }
    
}
