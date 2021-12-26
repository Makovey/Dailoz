//
//  ProfileController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 24.12.2021.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.parent?.navigationController?.popViewController(animated: true)
            DBHelper.userId = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

}
