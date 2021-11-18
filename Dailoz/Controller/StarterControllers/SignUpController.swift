//
//  SignUpController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 18.11.2021.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton()
    }
    
    
    func customizeButton() {
        signUpButton.layer.cornerRadius = 15.0
    }


}
