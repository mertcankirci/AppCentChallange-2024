//
//  Date+Ext.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import Foundation

extension Date {
    func convertToMonthYearDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: self)
    }
    
//MARK: Calculates the time difference between two dates and returns a formatted string representation.
    func formattedTimeDifference() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        
        if let day = components.day, day > 0 {
            if day == 1 {
                return "1 day"
            }
            return self.convertToMonthYearDayFormat()
        } else if let hour = components.hour, hour != 0 {
            return "\(abs(hour)) h"
        } else if let minute = components.minute, minute != 0 {
            return "\(abs(minute)) min)"
        } else if let second = components.second {
            return "\(abs(second)) sec)"
        } else {
            return "Now"
        }
    }
}
