//
//  Utilities.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 28.11.2021.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        textfield.layer.borderColor = UIColor.init(red: 125/255, green: 136/255, blue: 231/255, alpha: 1).cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 10.0
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
