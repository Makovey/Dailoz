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
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        print("My tasks \(tasks)")
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            DBHelper.getInfo { result in
//                self.usernameLabel.text = result![K.FStore.Field.name]! as? String
            }
        }
        
        DispatchQueue.main.async {
            DBHelper.getUserTasks { result in
                print("1")
                self.tasks = result!
                self.usernameLabel.text = String(self.tasks.count)
            }
        }
    }
}
