//
//  CommentTableCell.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var agreeCountLabel: UILabel!
    @IBOutlet weak var disagreeCountLabel: UILabel!
    
    @IBAction func accurateUp(_ sender: UIButton) {
    }
    
    @IBAction func notAccurateUp(_ sender: UIButton) {
    }
    
    @IBAction func notAccurateDown(_ sender: UIButton) {
    }
    
    @IBAction func accurateDown(_ sender: UIButton) {
    }
    
    // MARK: Variables
    var cellTag: Tag?
    
    // MARK: Actions
    @IBAction func clickAgreeUp(_ sender: Any) {
        cellTag?.upvoteAgree()
        agreeCountLabel.text = getAgreeScore()
    }
    
    @IBAction func clickDisagreeUp(_ sender: Any) {
        cellTag?.upvoteDisagree()
        disagreeCountLabel.text = getDisagreeScore()
    }
    
    @IBAction func clickDisagreeDown(_ sender: Any) {
        cellTag?.downvoteDisagree()
        disagreeCountLabel.text = getDisagreeScore()
    }
    
    @IBAction func clickAgreeDown(_ sender: Any) {
        cellTag?.downvoteAgree()
        agreeCountLabel.text = getAgreeScore()
    }
    
    private func getAgreeScore() -> String{
        return "\(cellTag!.agreeScore)"
    }
    
    private func getDisagreeScore() -> String{
        return "\(cellTag!.disagreeScore)"
    }

}
