//
//  Utilities.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 28.11.2021.
//

import Foundation
import UIKit
import NotificationBannerSwift

class Utilities {
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    private static let content = UNMutableNotificationContent()
    
    static func styleTextField(_ textfield:UITextField) {
        textfield.layer.borderColor = UIColor.init(red: 125/255, green: 136/255, blue: 231/255, alpha: 1).cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 10.0
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func showBunner(title: String, subtitle: String, style: BannerStyle) {
        let banner = GrowingNotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.titleLabel?.font = UIFont.init(name: K.mainFontBolt, size: 17)
        banner.subtitleLabel?.font = UIFont(name: K.mainFont, size: 13)
        banner.duration = 2.5
        banner.dismissOnSwipeUp = true
        banner.show(queuePosition: .front)
    }
    
    static func clearAllTextFields(textFields: [UITextField]) {
        for textField in textFields {
            textField.text = ""
        }
    }
    
    static func styleButton(_ button: UIButton, borderWidth: Double, borderColor: UIColor?) {
        button.layer.borderWidth = borderWidth
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
        }
    }
    
    static func scheduleNotificationToTask(_ task: Task, showBanner: Bool) {
        content.title = "Dailoz"
        content.sound = .default
        
        content.body = "\(task.title) starts now"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.year = Int(task.dateBegin.get(.year))
        dateComponents.month = Int(task.dateBegin.get(.month))
        dateComponents.day = Int(task.dateBegin.get(.day))
        dateComponents.hour = Int(task.startAt.get(.hour))
        dateComponents.minute = Int(task.startAt.get(.minute))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if error != nil {
                fatalError("Cannot create remainder cause \(error?.localizedDescription)")
            }
        }
        if showBanner {
            showBunner(title: "We remaind you about your task", subtitle: "In \(task.startAt.get(.hour)) : \(task.startAt.get(.minute))", style: .success)
        }
    }
}
