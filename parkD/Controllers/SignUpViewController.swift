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
    let passNames : [String] = ["Blue", "IM", "Green", "Bryan Research Garage", "PG4 - Visitor"]
    let passRef = FIRDatabase.database().reference(withPath: "parking-passes")
    let signUpClick             = "signUpClick"
    let cancel                  = "signUpCancel"
    let invalidEmailTitle       = "Invalid Email"
    let invalidEmailMessage     = "Sorry, your email address is not valid."
    let emptyEmailMessage       = "Please enter an email address."
    let invalidPasswordTitle    = "Invalid Password"
    let emptyPassMessage        = "Please enter a password."
    let passNotMatch            = "The passwords don't match."
    let invalidPasswordMessage  = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
    let invalidSignupTitle      = "Invalid signup"
    let invalidSignupMessage    = "Sorry, your signup is not valid."
    let emailTakenTitle         = "Email taken"
    let emailTakenMessage       = "Sorry, a user with that email already exists."
    
    // MARK: Variables
    var permitTypes     : [ParkingPass] = []
    var myPermit        : String!
 
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
        self.permitPicker.dataSource = self
        self.permitPicker.delegate = self
        //Dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        let email = getEmail()
        let pass = getPass()
        if(!UserVerifier().checkEmail(email: email)){
            displayMessage(title: invalidPasswordTitle, message: invalidPasswordTitle)
        }
        else if(!UserVerifier().checkPass(pass: pass)){
            displayMessage(title: invalidPasswordTitle, message: invalidPasswordMessage)
        }
        else if(myReTypePassword.text != myPassword.text){
            displayMessage(title: invalidPasswordTitle, message: passNotMatch)
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: pass) { (user, error) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.displayMessage(title: self.invalidSignupTitle, message: self.invalidSignupMessage)
                        return
                    case .errorCodeEmailAlreadyInUse:
                        self.displayMessage(title: self.emailTakenTitle, message: self.emailTakenMessage)
                        return
                    default:
                        self.displayMessage(title: self.invalidSignupTitle, message: self.invalidSignupMessage)
                        return
                    }
                }
            }
            self.signedUp(user!, email: email)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,sender: Any?) -> Bool {
        if(identifier == cancel){
            return true
        }
        return false
    }

    //Get the permits from Firebase
    private func getPermitTypes() {
        ParkingPassLoader().setDefaults()
        for name in passNames {
            passRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let number = value?["number"] as! Int64
                self.permitTypes.append(self.getPass(name: name, number: number))
                self.permitPicker.reloadAllComponents()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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
        return permitTypes[row].name
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myPermit = permitTypes[row].name
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
    
    private func signedUp(_ user: FIRUser?, email: String) {
        UserVerifier().addUserWithPermitToDB(email: email, permit: self.myPermit)
        performSegue(withIdentifier: signUpClick, sender: nil)
    }
    
    private func getPass(name: String, number: Int64) -> ParkingPass {
        return ParkingPass(name: name, number: number)
    }

}
