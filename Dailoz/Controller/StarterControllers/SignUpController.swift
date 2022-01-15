//
//  SignUpController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 18.11.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpController: UIViewController {
        
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardWhenTappedOut()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        styleElements()
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        signUp()
    }
    
    func signUp() {
        disableSignUpButton()
        if let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            if username.isEmpty {
                Utilities.showBunner(title: "Oh, we can't sign up", subtitle: "Please, fill username field", style: .danger)
                enableSignUpButton()
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    Utilities.showBunner(title: "Oh, we can't sign up", subtitle: e.localizedDescription, style: .danger)
                } else {
                    DBHelper.userId = Auth.auth().currentUser?.uid

                    DBHelper.saveDataTo(
                        collection: K.FStore.Collection.userInfo,
                        data: [
                            K.FStore.Field.name : username,
                            K.FStore.Field.email : email
                        ])
                    
                    DBHelper.loadUserInfo()
                    self.performSegue(withIdentifier: K.signUpSegue, sender: self)
                    self.passwordTextField.text = ""
                }
                self.enableSignUpButton()
            }
        }
    }
    
    func styleElements() {
        for textField in [usernameTextField, emailTextField, passwordTextField] {
            Utilities.styleTextField(textField!)
        }
    }
    
    func disableSignUpButton() {
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.8
    }
    
    func enableSignUpButton() {
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
    }
    
}

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            signUp()
        }
        
        return true
    }
}
