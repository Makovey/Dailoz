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

// MARK: - Show loader into view

extension UIViewController {
    
    weak var blurEffect: UIBlurEffect? {
        return UIBlurEffect(style: UIBlurEffect.Style.light)
    }
    
    weak var blurEffectView: UIVisualEffectView? {
        return UIVisualEffectView(effect: blurEffect)
    }
    
    weak var activityIndicator: UIActivityIndicatorView? {
        return UIActivityIndicatorView(style: .large)
    }
    
    func showLoaderWhileLoadingData() {
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView!)
        
//        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        
        activityIndicator?.startAnimating()

    }
    
    func removeLoader() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCurlDown) {
            self.blurEffectView?.alpha = 0.0
            self.activityIndicator?.alpha = 0.0
        } completion: { bool in
            self.activityIndicator?.stopAnimating()
            self.blurEffectView?.removeFromSuperview()
        }
    }
}

