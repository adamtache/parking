//
//  FilterViewController.swift
//  parkD
//
//  Created by Adam on 12/2/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var uiView: UIView!
    
    // MARK: Variables
    var validFilter = false
    var distanceFilter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFilterValues()
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
