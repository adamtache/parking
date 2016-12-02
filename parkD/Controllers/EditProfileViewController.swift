//
//  EditProfileViewController.swift
//  parkD
//
//  Created by Steven Katsohirakis on 11/20/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Mark: Constants
    let passNames : [String] = ["Blue", "IM", "Green", "Bryan Research Garage", "PG4 - Visitor"]
    let passRef = FIRDatabase.database().reference(withPath: "parking-passes")
    let missingFieldsTitle      = "Missing password fields"
    let missingFieldsMessage    = "You need to enter and re-enter your new password"
    let invalidPasswordTitle    = "Invalid Password"
    let invalidPasswordMessage  = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
    let passNotMatch            = "The passwords don't match."
    let editSuccess     = "editProfileSuccess"
    
    // MARK: Variables
    var permitTypes     : [ParkingPass] = []
    var myPermit        : String!
    private var user: User!
    
    // MARK: Outlets
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
        
        //Load the pickerView data from Firebase
        getPermitTypes()
        
        self.myPermitPicker.dataSource = self
        self.myPermitPicker.delegate = self
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
        
        UserModifier().changeEmail(email: user.email, newEmail: getEmail())
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
    
    func updatePermit() {
        UserModifier().changePermit(email: myEmailField.text!, newPermit: self.getSelectedPermit())
    }
    
    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            
        }
        controller.addAction(alertAction)
        present(controller, animated: true, completion: nil)
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
                self.myPermitPicker.selectRow(0, inComponent: 0, animated: true)
                self.myPermit = self.permitTypes[0].name
                self.myPermitPicker.reloadAllComponents()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func getPass(name: String, number: Int64) -> ParkingPass {
        return ParkingPass(name: name, number: number)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,sender: Any?) -> Bool {
        if (identifier == editSuccess) {
            updatePermit()
            return updateEmail() && updatePassword()
        }
        return true
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
    
    private func getSelectedPermit() -> String {
        return permitTypes[0].name
    }
 
}
