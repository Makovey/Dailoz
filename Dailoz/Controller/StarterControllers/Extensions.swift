//
//  Extensions.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 25.11.2021.
//

import UIKit

// MARK: - Dismiss keyboard when tapped outside

extension UIViewController {
    func dismissKeyboardWhenTappedOut() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}

