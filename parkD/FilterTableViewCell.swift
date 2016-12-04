//
//  FilterTableViewCell.swift
//  parkD
//
//  Created by Adam on 12/1/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    var delegate: SwitchChangedDelegate?
    var row: Int?
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet var cellSwitch: UISwitch!
    
    
    @IBAction func changedBoolValue(_ sender: UISwitch) {
        self.delegate?.changeStateTo(isOn: sender.isOn, row: row!)
    }
    
}
