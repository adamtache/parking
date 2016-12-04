//
//  FilterViewController.swift
//  parkD
//
//  Created by Adam on 12/2/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet var uiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getValidFilter() -> Bool {
        return self.getValidCell().cellSwitch.isOn
    }
    
    func getOpenFilter() -> Bool {
        return self.getOpenCell().cellSwitch.isOn
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
    
    private func getOpenCell() -> FilterTableViewCell {
        let openNowRow : NSIndexPath = NSIndexPath(row: 0, section: 0)
        return getFilterTableViewController().tableView.cellForRow(at: openNowRow as IndexPath) as! FilterTableViewCell
    }
    
    private func getClosestDistanceCell() -> FilterTableViewCell {
        let closestDistanceRow : NSIndexPath = NSIndexPath(row: 0, section: 0)
        return getFilterTableViewController().tableView.cellForRow(at: closestDistanceRow as IndexPath) as! FilterTableViewCell
    }
    
}
