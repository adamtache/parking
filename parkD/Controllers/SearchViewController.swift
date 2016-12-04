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
    
    // MARK: Variables
    var locationHandler : LocationHandler = LocationHandler()
    var user: User?
    var searchActive : Bool = false
    var items = [ParkingZone]()
    var filtered = [ParkingZone]()
    var listController : ParkingListTableViewController?
    var mapController : MapViewController?
    var mapActive : Bool = false
    var closestDistanceActive = true
    var validZoneActive = false
    var openZoneActive = false
    var preSearchItems = [ParkingZone]()
    
    // MARK: Constants
    let searchToFilter = "SearchToFilter"
    let mapIdentifier = "MapViewController"
    let listIdentifier = "ParkingListTableViewController"
    let profileIdentifier = "ProfileViewController"
    let mainIdentifier = "Main"
    let listTitle = "List"
    let mapTitle = "Map"
    let zoneRef = FIRDatabase.database().reference(withPath: "parking-lots")
    let userRef = FIRDatabase.database().reference(withPath: "user-info")
    let zoneNames : [String] = ["Blue", "IM", "Green", "Bryan Research Garage", "PG4 - Visitor"]
    
    // MARK: Outlets
    @IBOutlet weak var containerB: UIView!
    @IBOutlet weak var containerA: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        setupZones()
    }
    
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
    
    @IBAction func unwindFromFilterCancel(_ sender: UIStoryboardSegue) {
    }
    
    @IBAction func unwindFromFilter(_ sender: UIStoryboardSegue) {
        if (sender.source.isKind(of: FilterViewController.self)) {
            let source:FilterViewController = sender.source as! FilterViewController
            openZoneActive = source.getOpenFilter()
            closestDistanceActive = source.getClosestFilter()
            validZoneActive = source.getValidFilter()
            setupZones()
        }
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
        searchBar.delegate = self
        self.listController = getListController()
        self.mapController = getMapController()
        self.configureControllers(listController: listController!, mapController: mapController!)
        setupZones()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationHandler.lastLocation = locations.last!
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
        if(searchText == "") {
            setupZones()
        }
        let toFilter = listController == nil ? items : preSearchItems
        filtered = toFilter.filter({ (item) -> Bool in
            let tmp: NSString = item.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        updateZones(filtered: filtered)
    }
    
    private func containsZone(list: [ParkingZone], zone: ParkingZone) -> Bool {
        return list.contains(where: { $0 == zone })
    }
    
    private func getZone(name: String, addedByUser: String, capacity: Int, percentFull: Double, markerLat: Double, markerLong: Double)-> ParkingZone {
        return CreationHandler().getZone(name: name, addedByUser: addedByUser, capacity: capacity, percentFull: percentFull, markerLat: markerLat, markerLong: markerLong)
    }
    
    private func sortZones(toSort: [ParkingZone], closest: Bool) {
        if(closest){
            filtered = toSort.sorted() { $0.distanceAway < $1.distanceAway }
            preSearchItems = filtered
            listController?.items = filtered
            listController?.tableView.reloadData()
        }
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
        
        mapController.setLocationManager(locationHandler: locationHandler)
        listController.setLocationManager(locationHandler: locationHandler)
        
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
        mapController.didMove(toParentViewController: self)
    }
    
    private func getMapController() -> MapViewController {
        return UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: mapIdentifier) as! MapViewController
    }
    
    private func getListController() -> ParkingListTableViewController {
        return UIStoryboard(name: mainIdentifier, bundle: nil).instantiateViewController(withIdentifier: listIdentifier) as! ParkingListTableViewController
    }
    
    private func setupZones() {
        self.resetItems()
        for name in zoneNames {
            zoneRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let addedByUser = value?["addedByUser"] as? String ?? ""
                let capacity = value?["capacity"] as! Int
                let percentFull = value?["percentFull"] as! Double
                let markerLat = value?["markerLat"] as! Double
                let markerLong = value?["markerLong"] as! Double
                var zone = self.getZone(name: name, addedByUser: addedByUser, capacity: capacity, percentFull: percentFull, markerLat: markerLat, markerLong: markerLong)
                zone.distanceAway = DistanceHandler().getDistanceAway(locationHandler: self.locationHandler, zone: zone)
                self.addZone(zone: zone)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        self.listController?.tableView.reloadData()
    }
    
    private func addZone(zone: ParkingZone) {
        if(!containsZone(list: self.items, zone: zone)){
            self.items.append(zone)
        }
        userRef.child((user?.email.replacingOccurrences(of: ".", with: ","))!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            let permit = value?["permit"] as? String
            let pass : ParkingPass = ParkingPassLoader().getPass(pass: permit!)!
            
            // TODO: Integrate open now check
            
            if((!self.validZoneActive && !self.openZoneActive) || pass.isValidZoneRightNow(zone: zone.name)) {
                if(!self.containsZone(list: self.filtered, zone: zone)){
                    self.filtered.append(zone)
                    self.preSearchItems.append(zone)
                    self.updateZones(filtered: self.filtered)
                }
            }
            if(self.closestDistanceActive) {
                self.sortZones(toSort: self.filtered, closest: true)
                self.sortZones(toSort: self.preSearchItems, closest: true)
                self.sortZones(toSort: self.listController!.items, closest: true)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func updateZones(filtered: [ParkingZone]) {
        resetItems()
        if(self.closestDistanceActive) {
            self.sortZones(toSort: filtered, closest: true)
        }
        self.filtered = filtered
        self.preSearchItems = filtered
        self.listController?.items = filtered
        listController?.tableView.reloadData()
        for zone in filtered {
            mapController?.addZone(zone: zone)
        }
    }
    
    private func getDefaultUser() -> User{
        return User()
    }
    
    private func resetItems() {
        self.listController?.items = []
        self.filtered = []
        self.preSearchItems = []
        self.mapController?.clearMap()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == searchToFilter) {
            let filterController = segue.destination as! FilterViewController
            filterController.setFilters(validFilter: validZoneActive, openFilter: openZoneActive, distanceFilter: closestDistanceActive)
        }
    }
    
}
