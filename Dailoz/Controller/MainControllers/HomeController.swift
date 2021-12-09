//
//  HomeController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 29.11.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Home Controller called")
        updateUI()
    }
    
    func updateUI() {
        DBHelper.reloadUserTasks {
            print("Home Controller \(DBHelper.userTasks.count)")
            self.usernameLabel.text = String(DBHelper.userTasks.count)
        }
    }
}
