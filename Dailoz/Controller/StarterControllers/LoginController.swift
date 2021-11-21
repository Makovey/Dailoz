//
//  LoginController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 21.11.2021.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton()
    }
    
    func customizeButton() {
        loginButton.layer.cornerRadius = 15.0
    }
    
}
