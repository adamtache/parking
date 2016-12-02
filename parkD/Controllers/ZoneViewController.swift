//
//  ZoneViewController.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ZoneViewController: UIViewController {
    
    //MARK: Constants
    let unwindFromZone  = "unwindFromZoneViewController"
    
    //MARK: Vars
    var zone: ParkingZone!
    var userController : UserController?
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentsView: UITableView!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var capacityValLabel: UILabel!
    @IBOutlet weak var percentFullLabel: UILabel!

    // MARK: Actions
    @IBAction func refreshData(_ sender: Any) {
        updateInfo()
    }
    
    @IBAction func navigateButton(_ sender: Any) {
        let coordinate = CLLocationCoordinate2DMake(zone.markerLat, zone.markerLong)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = zone.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: unwindFromZone, sender: self)
    }
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        updateInfo()
    }
    
    private func updateInfo() {
        print("Zone: \(zone)")
        if (zone != nil) {
            nameLabel.text = zone.name
            capacityValLabel.text = String(zone.capacity)
            if(userController != nil){
                distanceLabel.text = DistanceCalculator.getDistanceString(userController: userController!, zone: zone)
            }
            percentFullLabel.text = String(zone.percentFull)
        }
    }

}
