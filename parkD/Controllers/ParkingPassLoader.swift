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
    var storedPasses : [String:ParkingPass] = [String:ParkingPass]()
    
    init() {
        setDefaults()
    }
    
    func getPass(pass: String) -> ParkingPass? {
        for (key, value) in storedPasses {
            if(key == pass){
                return value
            }
        }
        return nil
    }
    
    func getItems() -> [ParkingPass] {
        let passes : [ParkingPass] = []
        return passes
    }
    
    func setDefaults() {
        let bluePass = self.getBluePass()
        storeInDB(pass: bluePass)
        let imPass = self.getIMPass()
        storeInDB(pass: imPass)
        let greenPass = self.getGreenPass()
        storeInDB(pass: greenPass)
        let bryanPass = self.getBryanPass()
        storeInDB(pass: bryanPass)
        let visitorPass = self.getPG4VisitorPass()
        storeInDB(pass: visitorPass)
    }
    
    private func storeInDB(pass: ParkingPass) {
        let localPassRef = passRef.child(pass.name)
        localPassRef.setValue(pass.toAnyObject())
        storedPasses[pass.name] = pass
    }
    
    private func getBluePass() -> ParkingPass {
        let name = "Blue"
        let standardZones = ["Blue"]
        let afterZones = ["Blue"]
        return ParkingPass(name: name, standardZones: standardZones, afterHoursZones: afterZones)
    }
    
    private func getIMPass() -> ParkingPass {
        let name = "IM"
        let standardZones = ["IM"]
        let afterZones = ["IM"]
        return ParkingPass(name: name, standardZones: standardZones, afterHoursZones: afterZones)
    }
    
    private func getGreenPass() -> ParkingPass {
        let name = "Green"
        let standardZones = ["Green"]
        let afterZones = ["Green"]
        return ParkingPass(name: name, standardZones: standardZones, afterHoursZones: afterZones)
    }
    
    private func getBryanPass() -> ParkingPass {
        let name = "Bryan Research Garage"
        let standardZones = ["Bryan Research Garage"]
        let afterZones = ["Bryan Research Garage"]
        return ParkingPass(name: name, standardZones: standardZones, afterHoursZones: afterZones)
    }
    
    private func getPG4VisitorPass() -> ParkingPass {
        let name = "PG4 - Visitor"
        let standardZones = ["PG4 - Visitor"]
        let afterZones = ["PG4 - Visitor"]
        return ParkingPass(name: name, standardZones: standardZones, afterHoursZones: afterZones)
    }
    
}
