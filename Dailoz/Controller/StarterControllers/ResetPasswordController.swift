//
//  ResetPasswordController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 26.01.2022.
//

import UIKit
import FirebaseAuth

class ResetPasswordController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        Utilities.styleTextField(emailTextField)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendEmail()
    }
    
    func sendEmail() {
        if let email = emailTextField.text {
            if !Utilities.isEmailValid(email) {
                Utilities.showBunner(
                    title: "Check your email".localize(),
                    subtitle: "Please, enter your email in correct format".localize(),
                    style: .info)
                return
            } else {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        Utilities.showBunner(
                            title: "Oops".localize(),
                            subtitle: error.localizedDescription.localize(),
                            style: .warning)
                    } else {
                        Utilities.showBunner(title: "Success".localize(), subtitle: "Check your email and come back".localize(), style: .info)
                    }
                }
            }
        }
    }
}

extension ResetPasswordController: UITextViewDelegate {
    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        sendEmail()
        return true
    }
}
