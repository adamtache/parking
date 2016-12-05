//
//  Comment.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import Firebase

struct Tag {
    
    let key: String
    let name: String
    var agreeScore: Int
    var disagreeScore: Int
    let ref: FIRDatabaseReference?
    
    init(name: String, agreeScore: Int, disagreeScore: Int){
        // Initializes comment through parameters.
        self.name = name
        self.agreeScore = agreeScore
        self.disagreeScore = disagreeScore
        self.key = ""
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        // Initializes comment through Firebase data.
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        agreeScore = snapshotValue["agreeScore"] as! Int
        disagreeScore = snapshotValue["disagreeScore"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            // Creates data to be stored into Firebase database.
            "name": name,
            "agreeScore": agreeScore,
            "disagreeScore": disagreeScore
        ]
    }
    
    mutating func upvoteAgree() {
        agreeScore = agreeScore + 1
        ref?.setValue(toAnyObject())
    }
    
    mutating func downvoteAgree() {
        agreeScore = agreeScore - 1
        ref?.setValue(toAnyObject())
    }
    
    mutating func upvoteDisagree() {
        disagreeScore = disagreeScore + 1
        ref?.setValue(toAnyObject())
    }
    
    mutating func downvoteDisagree() {
        disagreeScore = disagreeScore - 1
        ref?.setValue(toAnyObject())
    }
    
}
