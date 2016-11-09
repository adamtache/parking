//
//  CommentTableCell.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    var comment: Comment?
    
    // MARK: Actions
    @IBAction func clickUpButton(_ sender: Any) {
        comment?.upvote()
        scoreLabel.text = "\(comment?.score)"
    }
    
    @IBAction func clickDownButton(_ sender: Any) {
        comment?.downvote()
        scoreLabel.text = "\(comment?.score)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
