//
//  DateUtilities.swift
//  news
//
//  Created by Benjamin Fantini on 9/2/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import Foundation

extension Date {
    
    func prettyTimeAgo() -> String {
 
        let componentUnitSet: Set<Calendar.Component> = [.year,
                                                         .month,
                                                         .day,
                                                         .hour,
                                                         .minute,
                                                         .second]
        
        let dateComponents = Calendar.current.dateComponents(componentUnitSet,
                                                             from: self,
                                                             to: Date())
        
        if let year = dateComponents.year, year > 0 {
            
            if year > 1 {
                return "Older than one year ago"
            } else {
                return "One year ago"
            }
            
        } else if let day = dateComponents.day, day > 0 {
            
            if day > 1 {
                return self.shortString()
            } else {
                return "Yesterday"
            }

        } else if let hour = dateComponents.hour, hour > 0 {
            return String(hour) + "h"
        } else if let minutes = dateComponents.hour, minutes > 0 {
            return String(minutes) + "m"
        } else if let second = dateComponents.second, second > 0 {
            return "now"
        }
        
        return ""
    }
    
    func shortString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return formatter.string(from: self)
    }
    
}
