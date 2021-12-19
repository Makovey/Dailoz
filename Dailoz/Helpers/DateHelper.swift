//
//  DateHelper.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 15.12.2021.
//

import Foundation

class DateHelper {
    
    private static let calendar = Calendar.current
    
    static func getHourAndMinutes(date: Date) -> DateComponents {
        return calendar.dateComponents([.hour, .minute], from: date)
    }
    
    static func getMonthAndDay(date: Date) -> DateComponents {
        return calendar.dateComponents([.month, .day], from: date)
    }
}

extension Date {
    
    func get(_ type: Calendar.Component) -> String {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return (t < 10 ? "0\(t)" : t.description)
    }
}
