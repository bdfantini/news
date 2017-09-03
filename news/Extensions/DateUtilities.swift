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
 
        // Units for date comparison's components
        let componentUnitSet: Set<Calendar.Component> = [.year,
                                                         .month,
                                                         .day,
                                                         .hour,
                                                         .minute,
                                                         .second]
        
        let dateComponents = Calendar.current.dateComponents(componentUnitSet,
                                                             from: self,
                                                             to: Date())
        
        // Custom string depending on the amount of time passed since the date
        // until now
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
            return "\(hour)h"
        } else if let minute = dateComponents.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = dateComponents.second, second > 0 {
            return "now"
        }
        
        return ""
    }
    
    func shortString() -> String {
        // Short format eg: Sep 2
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return formatter.string(from: self)
    }
    
}
