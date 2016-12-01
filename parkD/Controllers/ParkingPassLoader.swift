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
    let passNames : [String] = ["Blue"]
    
    init() {
    }
    
    func load() {
        setDefaults()
    }
    
    func getItems() -> [ParkingPass] {
        var passes : [ParkingPass] = []
        for name in passNames {
            passRef.child(name).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let number = value?["number"] as! Int64
                passes.append(self.getPass(name: name, number: number))
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        return passes
    }
    
    func setDefaults() {
        let bluePass = getPass(name: "Blue", number: 0)
        storeInDB(pass: bluePass)
    }
    
    private func storeInDB(pass: ParkingPass) {
        let bluePassRef = passRef.child(pass.name)
        bluePassRef.setValue(pass.toAnyObject())
    }
    
    private func getPass(name: String, number: Int64) -> ParkingPass {
        return ParkingPass(name: name, number: number)
    }
    
}
