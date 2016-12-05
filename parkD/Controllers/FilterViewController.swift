//
//  FilterViewController.swift
//  parkD
//
//  Created by Adam on 12/2/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit
import GooglePlaces

class FilterViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var destinationLabel: UILabel!
    
    // MARK: Variables
    var validFilter = false
    var distanceFilter = false
    var destination : CLLocationCoordinate2D?
    
    // MARK: Actions
    @IBAction func autocompleteClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFilterValues()
        destinationLabel.text = ""
    }
    
    private func setFilterValues() {
        self.getValidCell().cellSwitch.setOn(validFilter, animated: false)
        getFilterTableViewController().switches["Valid Permit"] = validFilter
        
        self.getClosestDistanceCell().cellSwitch.setOn(distanceFilter, animated: false)
        getFilterTableViewController().switches["Closest Distance"] = distanceFilter
    }
    
    func setFilters(validFilter: Bool, distanceFilter: Bool) {
        self.validFilter = validFilter
        self.distanceFilter = distanceFilter
    }
    
    func getValidFilter() -> Bool {
        return self.getValidCell().cellSwitch.isOn
    }
    
    func getClosestFilter() -> Bool {
        return self.getClosestDistanceCell().cellSwitch.isOn
    }
    
    private func getFilterTableViewController() -> FilterTableViewController {
        return childViewControllers[0] as! FilterTableViewController
    }
    
    private func getValidCell() -> FilterTableViewCell {
        let validPermitRow : NSIndexPath = NSIndexPath(row: 0, section: 0)
        return getFilterTableViewController().tableView.cellForRow(at: validPermitRow as IndexPath) as! FilterTableViewCell
    }
    
    private func getClosestDistanceCell() -> FilterTableViewCell {
        let closestDistanceRow : NSIndexPath = NSIndexPath(row: 1, section: 0)
        return getFilterTableViewController().tableView.cellForRow(at: closestDistanceRow as IndexPath) as! FilterTableViewCell
    }
}

extension FilterViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        destination = place.coordinate
        destinationLabel.text = place.name
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
