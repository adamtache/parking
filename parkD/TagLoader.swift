//
//  ParkingLotLoader.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class TagLoader {
    
    // MARK: Constants
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    let accurateVotersRef = FIRDatabase.database().reference(withPath: "accurateVoters")
    let notAccurateVotersRef = FIRDatabase.database().reference(withPath: "notAccurateVoters")
    
    // MARK: Variables
    var tags : [String] = ["Space Available", "Full", "Ticketing", "Towing", "Blocked"]
    var zones : [String] = ["Blue", "Bryan Research Garage", "Carr", "Green", "IM", "PG4 - Visitor", "Pegram", "Trent"]
    
    init() {
    }
    
    func setDefaults() {
        for zone in zones {
            let localTagRef = tagRef.child(zone)
            for tag in tags {
                var accurateVoters = [String:String]()
                accurateVoters["test"] = " "
                var notAccurateVoters = [String:String]()
                notAccurateVoters["test"] = " "
                print("About to create tag")
                let tag = getTag(name: tag, accurateAgreeScore: 0, accurateDisagreeScore: 0, notAccurateAgreeScore: 0, notAccurateDisagreeScore: 0, zoneName: zone, accurateVoters: accurateVoters, notAccurateVoters: notAccurateVoters)
                print("Tag created")
                storeInDB(tag: tag, localTagRef: localTagRef, zone: zone)
            }
        }
    }
    
    private func storeInDB(tag: Tag, localTagRef: FIRDatabaseReference, zone: String) {
        localTagRef.child(tag.name).setValue(tag.toAnyObject())
        print("Stored tag")
        print(tag.accurateVoters)
        accurateVotersRef.child(tag.name).child(zone).setValue(tag.accurateVoters)
        print("accurate stored")
        notAccurateVotersRef.child(tag.name).child(zone).setValue(tag.notAccurateVoters)
    }
    
    private func getTag(name: String, accurateAgreeScore: Int, accurateDisagreeScore: Int, notAccurateAgreeScore: Int, notAccurateDisagreeScore: Int, zoneName: String, accurateVoters: [String: String], notAccurateVoters: [String: String])
        -> Tag {
        return Tag(name: name, accurateAgreeScore: accurateAgreeScore, accurateDisagreeScore: accurateDisagreeScore, notAccurateAgreeScore: notAccurateAgreeScore, notAccurateDisagreeScore: notAccurateDisagreeScore, zoneName: zoneName, accurateVoters: accurateVoters, notAccurateVoters: notAccurateVoters)
    }

}
