//
//  ZoneViewController.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase

class ZoneViewController: UIViewController {
    
    //MARK: Constants
    let unwindFromZone  = "unwindFromZoneViewController"
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentsView: UITableView!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var capacityValLabel: UILabel!

    // MARK: Actions
    @IBAction func refreshData(_ sender: Any) {
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: unwindFromZone, sender: self)
    }
    
    
    var zone: ParkingZone!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
    }

}
