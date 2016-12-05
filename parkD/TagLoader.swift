//
//  ParkingLotLoader.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class TagLoader {
    
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    var tags : [String] = ["Space Available", "Full", "Ticketing", "Towing", "Blocked"]
    var lots : [String] = ["Blue", "Bryan Research Garage", "Carr", "Green", "IM", "PG4 - Visitor", "Pegram", "Trent"]
    
    init() {
    }
    
    func setDefaults() {
        for lot in lots {
            let localTagRef = tagRef.child(lot)
            for tag in tags {
                let tag = getTag(name: tag, accurateAgreeScore: 0, accurateDisagreeScore: 0, notAccurateAgreeScore: 0, notAccurateDisagreeScore: 0, zoneName: lot)
                storeInDB(tag: tag, localTagRef: localTagRef)
            }
        }
    }
    
    private func storeInDB(tag: Tag, localTagRef: FIRDatabaseReference) {
        localTagRef.child(tag.name).setValue(tag.toAnyObject())
    }
    
    private func getTag(name: String, accurateAgreeScore: Int, accurateDisagreeScore: Int, notAccurateAgreeScore: Int, notAccurateDisagreeScore: Int, zoneName: String) -> Tag {
        return Tag(name: name, accurateAgreeScore: accurateAgreeScore, accurateDisagreeScore: accurateDisagreeScore, notAccurateAgreeScore: notAccurateAgreeScore, notAccurateDisagreeScore: notAccurateDisagreeScore, zoneName: zoneName)
    }

}
