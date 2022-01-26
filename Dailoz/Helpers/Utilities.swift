//
//  Utilities.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 28.11.2021.
//

import Foundation
import UIKit
import NotificationBannerSwift

struct Utilities {
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    private static let content = UNMutableNotificationContent()
    
    // MARK: - Style
    
    static func styleTextField(_ textfield:UITextField) {
        textfield.layer.borderColor = UIColor.init(red: 125/255, green: 136/255, blue: 231/255, alpha: 1).cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 10.0
    }
    
    static func styleButton(_ button: UIButton, borderWidth: Double, borderColor: UIColor?) {
        button.layer.borderWidth = borderWidth
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: - TextFields
    
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func clearAllTextFields(textFields: [UITextField]) {
        for textField in textFields {
            textField.text = ""
        }
    }
    
    // MARK: - Show bunner
    
    static func showBunner(title: String, subtitle: String, style: BannerStyle) {
        let banner = GrowingNotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.titleLabel?.font = UIFont.init(name: K.mainFontBolt, size: 17)
        banner.subtitleLabel?.font = UIFont(name: K.mainFont, size: 13)
        banner.duration = 2.5
        banner.dismissOnSwipeUp = true
        banner.show(queuePosition: .front)
    }
    
    // MARK: - Notifications
    
    static func scheduleNotificationToTask(_ task: Task, showBanner: Bool) {
        content.title = "Dailoz"
        content.sound = .default
        
        content.body = "\(task.title) " + "starts now".localize()
        
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
            if let e = error {
                fatalError("Cannot create remainder cause: \(e.localizedDescription)")
            }
        }
        
        if showBanner {
            showBunner(title: "We remaind you about your task".localize(), subtitle: "In".localize() + " \(task.startAt.get(.hour)) : \(task.startAt.get(.minute))", style: .success)
        }
    }
    
    static func deleteNotificationById(_ id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // MARK: - Pickers
    
    static func setUpDatePicker(_ datePicker: UIDatePicker) {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = K.Color.mainPurple
    }
    
    static func setUpTimePicker(_ timePicker: UIDatePicker) {
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = .white
        timePicker.timeZone = .autoupdatingCurrent
        timePicker.tintColor = K.Color.mainPurple
    }
}
