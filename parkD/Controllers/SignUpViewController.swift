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
    
    private func checkFields() -> Bool{
        return checkEmail() && checkPass()
    }
    
    private func checkEmail() -> Bool{
        // Checks for valid email via regex.
        if (myEmail.text?.isEmpty)! {
            displayMessage(title: invalidEmailTitle, message: emptyEmailMessage)
            return false
        }
        let trimmedEmail = myEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = emailTest.evaluate(with: trimmedEmail)
        if (!isValid) {
            displayMessage(title: invalidEmailTitle, message: invalidEmailMessage)
        }
        return isValid
    }
    
    private func checkPass() -> Bool{
        // Checks for valid password via regex.
        if((myPassword.text?.isEmpty)! || (myReTypePassword.text?.isEmpty)!){
            displayMessage(title: invalidPasswordTitle, message: emptyPassMessage)
            return false
        }
        if(myPassword.text! != myReTypePassword.text!){
            displayMessage(title: invalidPasswordTitle, message: passNotMatch)
            return false
        }
        let passRegEx = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isValid = passTest.evaluate(with: myPassword.text!)
        if (!isValid) {
            displayMessage(title: invalidPasswordTitle, message: invalidPasswordMessage)
        }
        return isValid
    }
    
    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }
    

}
