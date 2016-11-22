//
//  EditProfileViewController.swift
//  parkD
//
//  Created by Steven Katsohirakis on 11/20/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //Mark: Constants
    let missingFieldsTitle      = "Missing password fields"
    let missingFieldsMessage    = "You need to enter and re-enter your new password"
    let invalidPasswordTitle    = "Invalid Password"
    let invalidPasswordMessage  = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
    let passNotMatch            = "The passwords don't match."
    let editSuccess     = "editProfileSuccess"

    //MARK: Vars
    private var user: User!

    //MARK: Outlets
    
    
    @IBOutlet weak var myEmailField: UITextField!
    @IBOutlet weak var myCurrentPassField: UITextField!
    @IBOutlet weak var myNewPassField: UITextField!
    @IBOutlet weak var myRetypePassField: UITextField!
    @IBOutlet weak var myPermitPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!user.email.isEmpty) {
            myEmailField.text = user.email
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func getEmail() -> String{
        return myEmailField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func updateEmail() -> Bool {
        //Check email format
        if(!UserVerifier().checkEmail(email: getEmail())){
            displayMessage(title: invalidPasswordTitle, message: invalidPasswordTitle)
            return false
        }
//        var oldUser = createUser(email: email, permit: "Blue")
//        return true//UserModifier().changeEmail(email: myEmailField.text!, newEmail: getEmail())
//        var oldUser = createUser(email: myEmailField.text, permit: "Blue")
//        let localUserRef = userRef.child((user?.email?.replacingOccurrences(of: ".", with: ","))!)
//        oldUser.email = myEmailField.text
//        localUserRef.setValue(oldUser.toAnyObject())
        return true
    }
    
    func updatePassword() -> Bool {
        //Only check password logic if current password field is not empty, so the user wants to change the password
        if (!(myCurrentPassField.text?.isEmpty)!) {
            //Check if either field is empty
            if ((myNewPassField.text?.isEmpty)! || (myRetypePassField.text?.isEmpty)!) {
                displayMessage(title: missingFieldsTitle, message: missingFieldsMessage)
                return false
            //Check if the password format is wrong
            } else if(!UserVerifier().checkPass(pass: myNewPassField.text!)) {
                displayMessage(title: invalidPasswordTitle, message: invalidPasswordMessage)
                return false
            //Check if the passwords don't match
            } else if(myRetypePassField.text! != myNewPassField.text!) {
                displayMessage(title: invalidPasswordTitle, message: passNotMatch)
                return false
            }
        }
        
        return UserModifier().changePass(email: myEmailField.text!, newPass: myNewPassField.text!)
    }
    
    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String,sender: Any?) -> Bool {
        if (identifier == editSuccess) {
            return updateEmail() && updatePassword()
        }
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 

}
