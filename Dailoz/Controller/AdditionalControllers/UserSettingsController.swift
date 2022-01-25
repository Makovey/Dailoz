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
                Utilities.showBunner(title: "Oops".localize(), subtitle: "Your current name is similar".localize(), style: .info)
            } else {
                DBHelper.updateUserInfo(data: [K.FStore.Field.name : newName]) {
                    Utilities.showBunner(title: "Woohoo".localize(), subtitle: "Now your name is".localize() + " - \(newName)", style: .success)
                }
                self.usernameTextField.text = ""
            }
        }
    }
    
    @IBAction func updateEmailPressed(_ sender: UIButton) {
        if let newEmail = emailTextField.text, let currentEmail = DBHelper.userInfo?.email {
            if !Utilities.isEmailValid(newEmail) {
                Utilities.showBunner(title: "Check your email".localize(), subtitle: "Please, enter your email in correct format".localize(), style: .info)
                return
            } else if newEmail == currentEmail {
                Utilities.showBunner(title: "Oops".localize(), subtitle: "Your current email is similar".localize(), style: .info)
                return
            } else {
                DBHelper.updateUserInfo(data: [K.FStore.Field.email : newEmail]) {
                    Utilities.showBunner(title: "Woohoo".localize(), subtitle: "Now your email is" + " - \(newEmail)", style: .success)
                }
                self.emailTextField.text = ""
            }
        }
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alertMeesage = "You definitely want to delete your account with tasks?".localize()
        let alert = UIAlertController(title: "Are you sure?".localize(), message: alertMeesage, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes".localize(), style: UIAlertAction.Style.default) { _ in
            DBHelper.deleteAccountAndTasks() {
                DBHelper.userId = nil
                DBHelper.userInfo = nil
                DBHelper.userTasks.removeAll()
                                                
                let navigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true, completion: nil)
            }
        })
                        
        alert.addAction(UIAlertAction(title: "No".localize(), style: UIAlertAction.Style.cancel, handler: nil))

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
