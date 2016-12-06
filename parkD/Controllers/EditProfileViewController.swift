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
    let passRef = FIRDatabase.database().reference(withPath: "parking-passes")
    let missingFieldsTitle      = "Missing password fields"
    let missingFieldsMessage    = "You need to enter and re-enter your new password"
    let invalidPasswordTitle    = "Invalid Password"
    let invalidPasswordMessage  = "Sorry, your password is not valid. Please include at least one uppercase letter, one number, and eight characters."
    let passNotMatch            = "The passwords don't match."
    let editSuccess             = "editProfileSuccess"
    
    // MARK: Variables
    var permitTypes     : [ParkingPass] = []
    var myPermit        : String!
    private var user: User!
    
    // MARK: Outlets
    @IBOutlet weak var myCurrentPassField: UITextField!
    @IBOutlet weak var myNewPassField: UITextField!
    @IBOutlet weak var myRetypePassField: UITextField!
    @IBOutlet weak var myPermitPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.myPermitPicker.dataSource = self
        self.myPermitPicker.delegate = self
        
        //Load the pickerView data from Firebase
        getPermitTypes()
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    //Keyboard dismissal
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func updatePassword() {
        //Only check password logic if current password field is not empty, so the user wants to change the password
        if (!(myCurrentPassField.text?.isEmpty)!) {
            //Check if either field is empty
            if ((myNewPassField.text?.isEmpty)! || (myRetypePassField.text?.isEmpty)!) {
                displayMessage(title: missingFieldsTitle, message: missingFieldsMessage)
                return
            //Check if the password format is wrong
            } else if(!UserVerifier().checkPass(pass: myNewPassField.text!)) {
                displayMessage(title: invalidPasswordTitle, message: invalidPasswordMessage)
                return
            //Check if the passwords don't match
            } else if(myRetypePassField.text! != myNewPassField.text!) {
                displayMessage(title: invalidPasswordTitle, message: passNotMatch)
                return
            }
        }
        
        UserModifier().changePass(email: user.email, newPass: myNewPassField.text!)
    }
    
    func updatePermit() {
        self.myPermitPicker.reloadAllComponents()
        if(self.myPermit == nil){
            if(permitTypes.count > 0){
                self.myPermit = self.permitTypes[0].name
            }
        }
        UserModifier().changePermit(email: user.email, newPermit: self.myPermit)
        
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
        passRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                // Get user value
                let value = rest.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let afterHoursZones = value?["afterHoursZones"] as! [String]
                let standardZones = value?["standardZones"] as! [String]
                let abbr = value?["abbr"] as! String
                self.permitTypes.append(ParkingPass(name: name, abbr: abbr, standardZones: standardZones, afterHoursZones: afterHoursZones))
                self.myPermitPicker.reloadAllComponents()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,sender: Any?) -> Bool {
        if (identifier == editSuccess) {
            updatePassword()
            updatePermit()
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if (segue.identifier == editSuccess) {
            let profileController = segue.destination as! ProfileViewController
            profileController.emailLabel.text = user.email
            profileController.permitLabel.text = self.myPermit
        }
    }
 
}
