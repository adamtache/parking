//
//  ParkingTableViewCell.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    var zone: ParkingZone?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
