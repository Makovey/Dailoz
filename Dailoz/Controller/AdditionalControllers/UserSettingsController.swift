//
//  UserSettingsController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 13.01.2022.
//

import UIKit

class UserSettingsController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        styleTextFields()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        
        setUpInitialData()
    }
    
    func setUpInitialData() {
        if let userData = DBHelper.userInfo {
            usernameTextField.text = userData.username
            emailTextField.text = userData.email
        }
    }
    
    @IBAction func updateNamePressed(_ sender: UIButton) {
        if let newName = usernameTextField.text, let currentName = DBHelper.userInfo?.username {
            if newName == currentName {
                Utilities.showBunner(title: "Oops", subtitle: "Your current name is similar", style: .info)
            } else {
                DBHelper.updateUserInfo(data: [K.FStore.Field.name : newName]) {
                    Utilities.showBunner(title: "Woohoo", subtitle: "Now your name is \(newName)", style: .success)
                }
                self.usernameTextField.text = ""
            }
        }
    }
    
    @IBAction func updateEmailPressed(_ sender: UIButton) {
        if let newEmail = emailTextField.text, let currentEmail = DBHelper.userInfo?.email {
            if !Utilities.isEmailValid(newEmail) {
                Utilities.showBunner(title: "Check your email", subtitle: "Please, enter your email in correct format", style: .info)
                return
            } else if newEmail == currentEmail {
                Utilities.showBunner(title: "Oops", subtitle: "Your current email is similar", style: .info)
                return
            } else {
                DBHelper.updateUserInfo(data: [K.FStore.Field.email : newEmail]) {
                    Utilities.showBunner(title: "Woohoo", subtitle: "Now your email is \(newEmail)", style: .success)
                }
                self.emailTextField.text = ""
            }
        }
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "You definitely want to delete your account with your tasks?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { _ in
            DBHelper.deleteAccountAndTasks() {
                DBHelper.userId = nil
                self.parent?.navigationController?.popViewController(animated: true)
            }
        })
                        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }


    func styleTextFields() {
        for textField in [usernameTextField, emailTextField] {
            Utilities.styleTextField(textField!)
        }
    }
}

extension UserSettingsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            self.view.endEditing(true)
        default: break
        }
        
        return true
    }
}
