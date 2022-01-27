//
//  SplashController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 22.01.2022.
//

import UIKit
import FirebaseAuth

class SplashController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            DBHelper.prepareData {
                if let newViewController = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                    newViewController.modalPresentationStyle = .fullScreen
                    self.present(newViewController, animated: true, completion: nil)
                }
            }
        } else {
            self.performSegue(withIdentifier: K.splashSegue, sender: self)
        }
    }
    
}
