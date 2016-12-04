//
//  TimeHandler.swift
//  parkD
//
//  Created by Adam on 12/3/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation

class TimeHandler {
    
    static func getCalendar() -> Calendar {
        return NSCalendar.current
    }
    
    static func getDate() -> NSDate {
        return NSDate()
    }
    
    static func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self.getDate() as Date)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
}
