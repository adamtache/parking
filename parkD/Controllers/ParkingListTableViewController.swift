//
//  ParkingListTableViewController.swift
//  parkD
//
//  Created by Adam on 11/8/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class ParkingListTableViewController: UITableViewController{
    
    var items: [ParkingLot] = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
}
