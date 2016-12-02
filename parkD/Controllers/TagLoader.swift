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
    
    init() {
        setDefaults()
    }
    
    func setDefaults() {
        let fullTag = getTag(name: "Full", agreeScore: 0, disagreeScore: 0)
        storeInDB(tag: fullTag)
        
        let spaceTag = getTag(name: "Space Available", agreeScore: 0, disagreeScore: 0)
        storeInDB(tag: spaceTag)
        
        let ticketingTag = getTag(name: "Ticketing", agreeScore: 0, disagreeScore: 0)
        storeInDB(tag: ticketingTag)
        
        let towingTag = getTag(name: "Towing", agreeScore: 0, disagreeScore: 0)
        storeInDB(tag: towingTag)
        
        let blockedTag = getTag(name: "Blocked", agreeScore: 0, disagreeScore: 0)
        storeInDB(tag: blockedTag)
    }
    
    private func storeInDB(tag: Tag) {
        let tagRef = self.tagRef.child(tag.name)
        tagRef.setValue(tag.toAnyObject())
    }
    
    private func getTag(name: String, agreeScore: Int, disagreeScore: Int) -> Tag {
        return Tag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore)
    }

}
