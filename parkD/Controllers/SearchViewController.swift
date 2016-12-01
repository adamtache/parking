//
//  SearchViewController.swift
//  parkD
//
//  Created by Adam on 12/1/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import FirebaseDatabase

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var containerB: UIView!
    @IBOutlet weak var containerA: UIView!
    
    var userController : UserController = UserController()
    var user: User?
    
    let zoneRef = FIRDatabase.database().reference(withPath: "parking-lots")
    let zoneNames : [String] = ["Blue"]
    
    // MARK: Constants
    let mapIdentifier = "MapViewController"
    let listIdentifier = "ParkingListTableViewController"
    let profileIdentifier = "ProfileViewController"
    let mainIdentifier = "Main"
    let listTitle = "List"
    let mapTitle = "Map"
    
    var searchActive : Bool = false
    var items = [ParkingZone]()
    var filtered = [ParkingZone]()
    
    var listController : ParkingListTableViewController?
    var mapController : MapViewController?
    
    var searchBar = UISearchBar()
    
    var mapActive : Bool = false
    
    @IBAction func flipButton(_ sender: UIBarButtonItem) {
        if(mapActive){
            UIView.animate(withDuration: 0.5, animations: {
                self.containerA.alpha = 1
                self.containerB.alpha = 0
                self.navigationItem.title = self.listTitle
                sender.title = self.mapTitle
            })
        }
        else{
            UIView.animate(withDuration: 0.5, animations: {
                self.containerA.alpha = 0
                self.containerB.alpha = 1
                self.navigationItem.title = self.mapTitle
                sender.title = self.listTitle
            })
        }
        mapActive = !mapActive
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        self.listController = getListController()
        self.mapController = getMapController()
        self.configureControllers(listController: listController!, mapController: mapController!)
        setupZones(listController: listController!, mapController: mapController!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        userController.lastLocation = locations.last!
    }
    
    private func configureControllers(listController: ParkingListTableViewController, mapController: MapViewController) {
        if(self.user != nil){
            listController.setUser(user: self.user!)
            mapController.setUser(user: self.user!)
        }
        else{
            let defaultUser = self.getDefaultUser()
            listController.setUser(user: defaultUser)
            mapController.setUser(user: defaultUser)
        }
        
        addChildViewController(listController)
        listController.view.translatesAutoresizingMaskIntoConstraints = false
        containerA.addSubview(listController.view)
        NSLayoutConstraint.activate([
            listController.view.leadingAnchor.constraint(equalTo: containerA.leadingAnchor),
            listController.view.trailingAnchor.constraint(equalTo: containerA.trailingAnchor),
            listController.view.topAnchor.constraint(equalTo: containerA.topAnchor),
            listController.view.bottomAnchor.constraint(equalTo: containerA.bottomAnchor)
            ])
        listController.didMove(toParentViewController: self)

        addChildViewController(mapController)
        mapController.view.translatesAutoresizingMaskIntoConstraints = false
        containerB.addSubview(mapController.view)
        NSLayoutConstraint.activate([
            mapController.view.leadingAnchor.constraint(equalTo: containerB.leadingAnchor),
            mapController.view.trailingAnchor.constraint(equalTo: containerB.trailingAnchor),
            mapController.view.topAnchor.constraint(equalTo: containerB.topAnchor),
            mapController.view.bottomAnchor.constraint(equalTo: containerB.bottomAnchor)
            ])
        listController.didMove(toParentViewController: self)
    }
    
    private func getMapController() -> MapViewController {
        let mapController = UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: mapIdentifier) as! MapViewController
        mapController.setLocationManager(userController: userController)
        if(self.user != nil){
            mapController.setUser(user: self.user!)
        }
        else{
            mapController.setUser(user: getDefaultUser())
        }
        return mapController
    }

    private func getListController() -> ParkingListTableViewController {
        let listController = UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: listIdentifier) as! ParkingListTableViewController
        
        listController.setLocationManager(userController: userController)
        return listController
    }
    
    private func setupZones(listController: ParkingListTableViewController, mapController: MapViewController) {
        for name in zoneNames {
            zoneRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let addedByUser = value?["addedByUser"] as? String ?? ""
                let capacity = value?["capacity"] as! Int
                let markerLat = value?["markerLat"] as! Double
                let markerLong = value?["markerLong"] as! Double
                let zone = self.getZone(name: name, addedByUser: addedByUser, capacity: capacity, markerLat: markerLat, markerLong: markerLong)
                self.items.append(zone)
                listController.items.append(zone)
                listController.tableView.reloadData()
                mapController.addZone(zone: zone)
                print(zone)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func getZone(name: String, addedByUser: String, capacity: Int, markerLat: Double, markerLong: Double)-> ParkingZone {
        let overlayColor = UIColor.blue
        let image = UIImage(named: "defaultPhoto")!
        return ParkingZone(name: name, addedByUser: addedByUser, key: "", capacity: capacity, overlayColor: overlayColor, markerLat: markerLat, markerLong: markerLong, image: image)
    }
    
    private func getDefaultUser() -> User{
        return User()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = items.filter({ (item) -> Bool in
            let tmp: NSString = item.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.listController?.filtered = filtered
    }
    
}
