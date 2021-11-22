//
//  SignUpController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 18.11.2021.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton()
        customizeTextInput()
    }
    
    
    func customizeButton() {
        signUpButton.layer.cornerRadius = 15.0
    }
    
    func customizeTextInput() {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textFields[0].frame.height, width: textFields[0].frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.red.cgColor
        
        textFields[0].borderStyle = .none
        
        textFields[0].layer.addSublayer(bottomLine)
    }
}
