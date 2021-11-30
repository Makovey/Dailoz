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
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardWhenTappedOut()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        stylingElements()
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        signUp()
    }
    
    func signUp() {
        if let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            if username.isEmpty {
                errorLabel.text = "Fill Username field"
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    DBHelper.saveDataToDB(
                        collection: K.FStore.userInfoCollection,
                        documentName: DBHelper.userUid!,
                        data: [
                            K.FStore.nameField : username,
                            K.FStore.emailField : email
                        ])
                    self.performSegue(withIdentifier: K.signUpSegue, sender: self)
                }
            }
        }
    }
    
    func stylingElements() {
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
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
