//
//  Comment.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    
    let key: String
    let user: String
    let time: String
    let comment: String
    let score: Int
    let ref: FIRDatabaseReference?
    
    init(key: String, user: String, time: String, comment: String, score: Int){
        // Initializes comment through parameters.
        self.key = key
        self.user = user
        self.time = time
        self.comment = comment
        self.score = score
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        // Initializes comment through Firebase data.
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        user = snapshotValue["user"] as! String
        time = snapshotValue["time"] as! String
        comment = snapshotValue["comment"] as! String
        score = snapshotValue["score"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            // Creates data to be stored into Firebase database.
            "user": user,
            "time": time,
            "comment": comment,
            "score": score
        ]
    }
    
    func upvote() {
        // Attempts to upvote comment.
    }
    
    func downvote() {
        // Attempts to downvote comment.
    }
    
}
