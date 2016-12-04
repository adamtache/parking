//
//  Pass.swift
//  parkD
//
//  Created by Adam on 11/16/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct ParkingPass: Equatable {
    
    let name: String
    let ref: FIRDatabaseReference?
    var standardZones: [String]
    var afterHoursZones: [String]
    
    init(name: String, standardZones: [String], afterHoursZones: [String]) {
        
        // Initializes pass through parameters.
        self.name = name
        self.ref = nil
        self.standardZones = standardZones
        self.afterHoursZones = afterHoursZones
    }
    
    init(snapshot: FIRDataSnapshot){
        
        // Initializes pass through Firebase data called 'FIRDataSnapshot'.
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        standardZones = snapshotValue["standardZones"] as! [String]
        afterHoursZones = snapshotValue["afterHoursZones"] as! [String]
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            
            // Creates data to be stored into Firebase database.
            
            "name": name,
            "standardZones": standardZones,
            "afterHoursZones": afterHoursZones
        ]
    }
    
    func isValidZoneRightNow(zone: String) -> Bool {
        if(self.isAfterHours()){
            return afterHoursZones.contains(zone)
        }
        return standardZones.contains(zone)
    }
    
    static func == (lhs: ParkingPass, rhs: ParkingPass) -> Bool {
        return lhs.name == rhs.name
    }
    
    private func isAfterHours() -> Bool {
        let now = TimeHandler.getDate() as Date
        let sevenam_today = TimeHandler.dateAt(hours: 7, minutes: 0)
        let fivepm_today = TimeHandler.dateAt(hours: 17, minutes: 0)
        return now >= sevenam_today && now < fivepm_today
    }
    
}
