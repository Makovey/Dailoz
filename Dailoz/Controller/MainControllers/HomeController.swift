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
        updateUI()
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            DBHelper.loadInfo { result in
                self.usernameLabel.text = result![K.FStore.Field.name]! as? String
            }
        }
    }
}
