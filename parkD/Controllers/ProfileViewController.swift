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
    
    //MARK: Variables
    var user            : User!
    
    // MARK: Actions
    @IBAction func signOutClick(_ sender: Any) {
        //Verify if user wants to sign out
        displayMessage(title: signoutTitle, message: signoutMessage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }

    private func displayMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Confirms the user goes back to the login screen
        let signoutAction = UIAlertAction(title: signoutText, style: .destructive) { (action) in
            print("should go back to login screen")
            self.performSegue(withIdentifier: self.signoutSegue, sender: self)
            try! FIRAuth.auth()!.signOut()
        }
        //Will cancel
        let cancelAction = UIAlertAction(title: cancelText, style: .destructive) { (action) in
            //No action for cancel
        }
        controller.addAction(signoutAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }

}
