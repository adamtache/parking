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
    let loginSuccessful = "LoginSuccessful"
    let goToSignUp = "GoToSignUp"
    
    let invalidEmailTitle = "Invalid Email"
    let invalidEmailMessage = "Sorry, your email address is not valid."
    let invalidPasswordTitle = "Invalid Password"
    let invalidPasswordMessage = "Sorry, your email address is not valid."
    
    let invalidLoginTitle = "Invalid Login"
    let invalidLoginMessage = "Sorry, your login is not valid."

    // MARK: Outlets
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    @IBAction func signInClicked(_ sender: Any) {
        let email = getEmail()
        let pass = getPass()
        if(!UserVerifier().checkEmail(email: email) || !UserVerifier().checkPass(pass: pass)){
            signInFailed()
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: pass) { (user, error) in
            if error != nil {
                self.signInFailed()
                return
            }
            self.signedIn(user!)
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: goToSignUp, sender: nil)
    }
    
    // MARK: Actions
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue){
        if(segue.identifier == loginSuccessful){
            performSegue(withIdentifier: loginToList, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss the keyboard
        self.dismissKeyboardAction()
        
        if (FIRAuth.auth()?.currentUser) != nil {
            self.performSegue(withIdentifier: self.loginToList, sender: nil)
        }
    }
    
    private func dismissKeyboardAction() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func signInFailed() {
        displayMessage(title: invalidLoginTitle, message: invalidLoginMessage)
    }
    
    // MARK: Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Password text will be erased
        passText.text = ""
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func getEmail() -> String{
        // Returns user input in email box
        return emailText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    private func getPass() -> String{
        // Returns user input in pass box
        return passText.text!
    }
    
    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func signedIn(_ user: FIRUser?) {
        performSegue(withIdentifier: loginToList, sender: nil)
    }
    
}
