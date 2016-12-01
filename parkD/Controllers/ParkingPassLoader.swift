//
//  ParkingLotLoader.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Firebase

class ParkingPassLoader {
    
    let passRef = FIRDatabase.database().reference(withPath: "parking-passes")
    let passNames : [String] = ["Blue", "IM", "Green", "Bryan Research Garage", "PG4 - Visitor"]
    
    init() {
        setDefaults()
    }
    
    func getItems() -> [ParkingPass] {
        var passes : [ParkingPass] = []
        return passes
    }
    
    func setDefaults() {
        let bluePass = getPass(name: "Blue", number: 0)
        storeInDB(pass: bluePass)
        let imPass = getPass(name: "IM", number: 1)
        storeInDB(pass: imPass)
        let greenPass = getPass(name: "Green", number: 2)
        storeInDB(pass: greenPass)
        let bryanPass = getPass(name: "Bryan Research Garage", number: 3)
        storeInDB(pass: bryanPass)
        let visitorPass = getPass(name: "PG4 - Visitor", number: 4)
        storeInDB(pass: visitorPass)
    }
    
    private func storeInDB(pass: ParkingPass) {
        let bluePassRef = passRef.child(pass.name)
        bluePassRef.setValue(pass.toAnyObject())
    }
    
    private func getPass(name: String, number: Int64) -> ParkingPass {
        return ParkingPass(name: name, number: number)
    }
    
}
