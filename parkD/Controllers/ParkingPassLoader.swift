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
    
    init() {
    }
    
    func getItems() -> [ParkingPass] {
        // TODO: Grab this from Firebase
        return getDefaults()
    }
    
    func getDefaults() -> [ParkingPass] {
        var passes : [ParkingPass] = []
        let bluePass = getBluePass()
        let bluePassRef = passRef.child(bluePass.name)
        bluePassRef.setValue(bluePass.toAnyObject())
        passes.append(bluePass)
        return passes
    }
    
    private func getBluePass() -> ParkingPass {
        let name = "Blue"
        return ParkingPass(name: name, number: 0)
    }
    
}
