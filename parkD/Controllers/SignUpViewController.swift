//
//  SignUpViewController.swift
//  parkD
//
//  Created by ece on 11/12/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Constants

    let success                 = "signUpSuccess"
    let invalidEmailTitle       = "Invalid Email"
    let invalidEmailMessage     = "Sorry, your email address is not valid."
    let emptyEmailMessage       = "Please enter an email address."
    let invalidPasswordTitle    = "Invalid Password"
    let emptyPassMessage        = "Please enter a password."
    let passNotMatch            = "The passwords don't match."
    let invalidPasswordMessage  = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
    
    // MARK: Variables
    var permitTypes     = ["Blue", "Commuter", "Green", "Faculty", "East"]
    var myPermit        : String!
    
//    let success = "signUpSuccess"
//    let invalidEmailTitle = "Invalid Email"
//    let invalidEmailMessage = "Sorry, your email address is not valid."
//    let emptyEmailMessage = "Please enter an email address."
//    let invalidPasswordTitle = "Invalid Password"
//    let emptyPassMessage = "Please enter a password."
//    let passNotMatch = "The passwords don't match."
//    let invalidPasswordMessage = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
 
    // MARK: Outlets
    @IBOutlet weak var myEmail: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myReTypePassword: UITextField!
    @IBOutlet weak var permitPicker: UIPickerView!
    
    // MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the pickerView data from Firebase
        getPermitTypes()
        
        //Set up the UIPickerView delegates
        self.permitPicker.dataSource = self;
        self.permitPicker.delegate = self;
        //Dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
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
    

    //Get the permits from Firebase
    func getPermitTypes() {
        
        
        //TODO: Assign the values of permitTypes based off what's on Firebase.
        //Currently, they are given default values at the top of the file
        
        //Set default pickerView selection
        permitPicker.selectRow(0, inComponent: 0, animated: true)
        myPermit = permitTypes[0]
    }
    
    //Add the Duke permits to the UIPickerView
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return permitTypes.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return permitTypes[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        myPermit = permitTypes[row]
        print("the new selected permit is \(myPermit)")
    }
    
//    private func checkFields() -> Bool{
//        return checkEmail() && checkPass()
//}
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
