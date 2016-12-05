//
//  CommentTableCell.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    // MARK: Variables
    var cellTag: Tag?
    var delegate: TagVoteChanged?
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var agreeCountLabel: UILabel!
    @IBOutlet weak var disagreeCountLabel: UILabel!
    
    // MARK: Actions
    @IBAction func clickAgreeUp(_ sender: UIButton) {
        cellTag?.clickAccurateUp()
        self.delegate?.changedState()
    }
    
    @IBAction func clickDisagreeUp(_ sender: UIButton) {
        cellTag?.clickNotAccurateUp()
        self.delegate?.changedState()
    }
    
    @IBAction func clickDisagreeDown(_ sender: UIButton) {
        cellTag?.clickNotAccurateDown()
        self.delegate?.changedState()
    }
    
    @IBAction func clickAgreeDown(_ sender: UIButton) {
        cellTag?.clickAccurateDown()
        self.delegate?.changedState()
    }

}
