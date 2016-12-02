//
//  ParkingLotLoader.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class TagLoader {
    
    let passRef = FIRDatabase.database().reference(withPath: "tags")
    var tags : [String] = ["Space Available", "Full", "Ticketing", "Towing", "Blocked"]
    
    init() {
    }
    
    func getItems() -> [Tag] {
        // TODO: Grab this from Firebase
        return getDefaults()
    }
    
    func getDefaults() -> [Tag] {
        var tags : [Tag] = []
        let fullTag = getFullTag()
        let fullTagRef = passRef.child(fullTag.name)
        fullTagRef.setValue(fullTag.toAnyObject())
        tags.append(fullTag)
        return tags
    }
    
    private func getFullTag() -> Tag {
        let name = "Full"
        let agreeScore = 0
        let disagreeScore = 0
        let lastAgree = 0
        let lastDisagree = 0
        return Tag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore, lastAgree: lastAgree, lastDisagree: lastDisagree)
    }
    
    private func getAllTags() -> [Tag] {
        var tagRet : [Tag] = []
        for name in tags {
            let name = name
            let agreeScore = 0
            let disagreeScore = 0
            let lastAgree = 0
            let lastDisagree = 0
            tagRet.append(Tag(name: name, agreeScore: agreeScore, disagreeScore: disagreeScore, lastAgree: lastAgree, lastDisagree: lastDisagree))
        }

        return tagRet
    }

}
