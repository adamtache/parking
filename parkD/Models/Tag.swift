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
    var accurateAgreeScore: Int
    var accurateDisagreeScore: Int
    var notAccurateAgreeScore: Int
    var notAccurateDisagreeScore: Int
    let ref: FIRDatabaseReference?
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    var zoneName: String
    
    init(name: String, accurateAgreeScore: Int, accurateDisagreeScore: Int, notAccurateAgreeScore: Int, notAccurateDisagreeScore: Int, zoneName: String){
        // Initializes comment through parameters.
        self.name = name
        self.accurateAgreeScore = accurateAgreeScore
        self.accurateDisagreeScore = accurateDisagreeScore
        self.notAccurateAgreeScore = accurateAgreeScore
        self.notAccurateDisagreeScore = accurateDisagreeScore
        self.key = ""
        self.zoneName = zoneName
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        // Initializes comment through Firebase data.
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        zoneName = snapshotValue["zoneName"] as! String
        accurateAgreeScore = snapshotValue["accurateAgreeScore"] as! Int
        accurateDisagreeScore = snapshotValue["accurateDisagreeScore"] as! Int
        notAccurateAgreeScore = snapshotValue["notAccurateAgreeScore"] as! Int
        notAccurateDisagreeScore = snapshotValue["notAccurateDisagreeScore"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            // Creates data to be stored into Firebase database.
            "name": name,
            "accurateAgreeScore": accurateAgreeScore,
            "accurateDisagreeScore": accurateDisagreeScore,
            "notAccurateAgreeScore": notAccurateAgreeScore,
            "notAccurateDisagreeScore": notAccurateDisagreeScore,
            "zoneName": zoneName
        ]
    }
    
    mutating func clickAccurateUp() {
        accurateAgreeScore = accurateAgreeScore + 1
        self.updateDB()
    }
    
    mutating func clickNotAccurateUp() {
        notAccurateAgreeScore = notAccurateAgreeScore + 1
        self.updateDB()
    }
    
    mutating func clickAccurateDown() {
        accurateDisagreeScore = accurateDisagreeScore + 1
        self.updateDB()
    }
    
    mutating func clickNotAccurateDown() {
        notAccurateDisagreeScore = notAccurateDisagreeScore + 1
        self.updateDB()
    }
    
    private func updateDB() {
        tagRef.child(zoneName).child(name).setValue(toAnyObject())
    }
    
}
