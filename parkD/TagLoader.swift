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
        print("Setting default")
        for lot in lots {
            print("Lot \(lot)")
            let localTagRef = tagRef.child(lot)
            
            let fullTag = getTag(name: "Full", agreeScore: 0, disagreeScore: 0)
            storeInDB(tag: fullTag, localTagRef: localTagRef)
            
            let spaceTag = getTag(name: "Space Available", agreeScore: 0, disagreeScore: 0)
            storeInDB(tag: spaceTag, localTagRef: localTagRef)
            
            let ticketingTag = getTag(name: "Ticketing", agreeScore: 0, disagreeScore: 0)
            storeInDB(tag: ticketingTag, localTagRef: localTagRef)
            
            let towingTag = getTag(name: "Towing", agreeScore: 0, disagreeScore: 0)
            storeInDB(tag: towingTag, localTagRef: localTagRef)
            
            let blockedTag = getTag(name: "Blocked", agreeScore: 0, disagreeScore: 0)
            storeInDB(tag: blockedTag, localTagRef: localTagRef)
        }
        
    }
    
    private func storeInDB(tag: Tag, localTagRef: FIRDatabaseReference) {
        localTagRef.child(tag.name).setValue(tag.toAnyObject())
    }
    
    private func getTag(name: String, agreeScore: Int, disagreeScore: Int) -> Tag {
        return Tag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore)
    }

}
