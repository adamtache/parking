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
    var locationHandler : LocationHandler?
    let zoneRef = FIRDatabase.database().reference(withPath: "parking-lots")
    
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
        print("Refreshing")
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
        zoneRef.child(zone.name).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let addedByUser = value?["addedByUser"] as? String ?? ""
            let capacity = value?["capacity"] as! Int
            let percentFull = value?["percentFull"] as! Double
            let markerLat = value?["markerLat"] as! Double
            let markerLong = value?["markerLong"] as! Double
            print("Percent full: \(percentFull)")
            var zone = self.getZone(name: name, addedByUser: addedByUser, capacity: capacity, percentFull: percentFull, markerLat: markerLat, markerLong: markerLong)
            zone.distanceAway = DistanceHandler().getDistanceAway(locationHandler: self.locationHandler!, zone: zone)
            self.updateLabels(name: name, capacity: capacity, percentFull: percentFull)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func updateLabels(name: String, capacity: Int, percentFull: Double) {
        nameLabel.text = name
        capacityValLabel.text = "\(capacity)"
        if(locationHandler != nil){
            distanceLabel.text = DistanceHandler().getDistanceString(locationHandler: locationHandler!, zone: zone)
        }
        percentFullLabel.text = String(percentFull)
    }
    
    private func getZone(name: String, addedByUser: String, capacity: Int, percentFull: Double, markerLat: Double, markerLong: Double)-> ParkingZone {
        return CreationHandler().getZone(name: name, addedByUser: addedByUser, capacity: capacity, percentFull: percentFull, markerLat: markerLat, markerLong: markerLong)
    }
    
    private func setupTagController() {
        
    }

}
