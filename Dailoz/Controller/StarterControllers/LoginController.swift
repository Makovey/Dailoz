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
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardWhenTappedOut()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        stylingElements()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        authenticate()
    }
    
    
    func authenticate() {
        if let email = loginTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
    func stylingElements() {
        Utilities.styleTextField(loginTextField)
        Utilities.styleTextField(passwordTextField)
    }
    
}

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.isSecureTextEntry {
            passwordTextField.becomeFirstResponder()
        } else {
            authenticate()
        }
        return true
    }
    
}
