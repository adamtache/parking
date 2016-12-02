//
//  ProfileViewController.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    //MARK: Constants
    let signoutTitle    = "Sign Out"
    let signoutMessage  = "Are you sure you want to sign out?"
    let signoutText     = "Yes"
    let cancelText      = "Cancel"
    let signoutSegue    = "signout"
    let editSuccess     = "editProfileSuccess"
    let editPressed     = "editProfilePressed"
    let editCancel      = "editProfileCancelled"
    let userRef = FIRDatabase.database().reference(withPath: "user-info")
    
    // MARK: Outlets
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var permitLabel: UILabel!
    
    //MARK: Variables
    var myUser            : User!
    
    // MARK: Actions
    @IBAction func signOutClick(_ sender: Any) {
        //Verify if user wants to sign out
        displayMessage(title: signoutTitle, message: signoutMessage)
    }
    
    @IBAction func unwindToProfile(_ segue: UIStoryboardSegue) {
    }
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func setUser(user: User) {
        self.myUser = user
    }
    
    private func setupLabels() {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // Test value of user
            if user != nil {
                // Login validated; Continue to display information
                self.myUser = User(authData: user!)
                self.userRef.child(self.myUser.email.replacingOccurrences(of: ".", with: ",")).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user values
                    let value = snapshot.value as? [String: AnyObject]
                    if(value == nil){
                        return;
                    }
                    let email = value?["email"] as! String
                    let permit = value?["permit"] as! String
                    // Set user values as labels
                    self.updateLabels(emailLabel: email, permitLabel: permit)
                }) { (error) in
                }
            }
            else{
                self.navigationItem.leftBarButtonItem = nil
                return;
            }
        }
    }
    
    private func updateLabels(emailLabel: String, permitLabel: String) {
        self.emailLabel.text = emailLabel
        self.permitLabel.text = permitLabel
    }
    
    private func signOut() {
        UserVerifier().signOut()
        if (FIRAuth.auth()?.currentUser) == nil {
            self.performSegue(withIdentifier: self.signoutSegue, sender: self)
        }
    }

    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Confirms the user goes back to the login screen
        let signoutAction = UIAlertAction(title: signoutText, style: .destructive) { (action) in
            self.signOut()
        }
        //Will cancel
        let cancelAction = UIAlertAction(title: cancelText, style: .destructive) { (action) in
            //No action for cancel
        }
        controller.addAction(signoutAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if (segue.identifier == editPressed) {
            let navController = segue.destination as! UINavigationController
            let viewController = navController.topViewController as! EditProfileViewController
            // Pass the selected object to the new view controller.
            if (myUser != nil) {
                viewController.setUser(user: myUser)
            }
        }
    }

}
