//
//  DateHelper.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 15.12.2021.
//

import Foundation

class DateHelper {
    
    private static let calendar = Calendar.current
    
    static func getsHourAndMinutes(date: Date) -> DateComponents {
        return calendar.dateComponents([.hour, .minute], from: date)
    }
}
