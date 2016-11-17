//
//  SignUpViewController.swift
//  parkD
//
//  Created by ece on 11/12/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: Constants
    let success = "signUpSuccess"
    let invalidEmailTitle = "Invalid Email"
    let invalidEmailMessage = "Sorry, your email address is not valid."
    let emptyEmailMessage = "Please enter an email address."
    let invalidPasswordTitle = "Invalid Password"
    let emptyPassMessage = "Please enter a password."
    let passNotMatch = "The passwords don't match."
    let invalidPasswordMessage = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
 
    // MARK: Outlets
    @IBOutlet weak var myEmail: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myReTypePassword: UITextField!
    @IBOutlet weak var permitPicker: UIPickerView!
    
    // MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,sender: Any?) -> Bool {
        print("trying to segue")
        if(identifier == success) {
            let email = getEmail()
            let pass = getPass()
            if(!UserVerifier().checkEmail(email: email)){
                displayMessage(title: invalidPasswordTitle, message: invalidPasswordTitle)
                return false
            }
            else if(!UserVerifier().checkPass(pass: pass)){
                displayMessage(title: invalidPasswordTitle, message: invalidPasswordMessage)
                return false
            }
            else if(myReTypePassword.text != myPassword.text){
                displayMessage(title: invalidPasswordTitle, message: passNotMatch)
                return false
            }
            if (UserVerifier().checkSignup(email: email, pass: pass)) {
                return true
            } else {
                return false
            }
        }
        print("signup not successful")
        return false
    }
    
    private func getEmail() -> String{
        return myEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    private func getPass() -> String{
        return myPassword.text!
    }
    
    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }

}
