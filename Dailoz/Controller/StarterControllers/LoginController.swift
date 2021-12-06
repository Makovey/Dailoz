//
//  LoginController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 21.11.2021.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardWhenTappedOut()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        styleElements()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }
    
    
    func login() {
        if let email = loginTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    Utilities.showBunner(title: "Oh, we can't login", subtitle: e.localizedDescription, style: .danger)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
    func styleElements() {
        for textField in [loginTextField, passwordTextField] {
            Utilities.styleTextField(textField!)
        }
    }
    
}

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login()
        }
        return true
    }
    
}
