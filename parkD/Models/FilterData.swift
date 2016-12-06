//
//  FilterData.swift
//  parkD
//
//  Created by Adam on 12/5/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import GooglePlaces

class FilterData {
    
    var validFilter = false
    var distanceFilter = false
    var destination : CLLocationCoordinate2D?
    
    init(validFilter: Bool, distanceFilter: Bool, destination: CLLocationCoordinate2D?) {
        self.validFilter = validFilter
        self.distanceFilter = distanceFilter
        self.destination = destination
    }
    
    init() {
        self.validFilter = false
        self.distanceFilter = true
        self.destination = nil
    }
    
}
