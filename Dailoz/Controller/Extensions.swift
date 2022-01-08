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

// MARK: - Extensions for NotificationCenter name

extension Notification.Name {
    static let cellDeleted = Notification.Name("cellDeleted")
    static let notification = Notification.Name("notification")
}

// MARK: - Extension for empty TableView

extension UITableView {
    func setImageWithMessage(_ message: String) {
        // create image with imageView
        let image = UIImage(named: "emptyTask")
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .top
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width / 3, height: self.bounds.size.height / 3)
        
        // create message label and set up
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = K.Color.mainBlue
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: K.mainFont, size: 14)

        // create labelView for messageLabel
        let labelView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        labelView.addSubview(messageLabel)
        
        imageView.addSubview(labelView)
        
        // create constraint for label view
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.topAnchor.constraint(equalTo: imageView.layoutMarginsGuide.topAnchor, constant: 40).isActive = true
        
        
        self.backgroundView = imageView
        
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
