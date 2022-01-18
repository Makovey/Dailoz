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
    
    @IBOutlet weak var inProgressView: UIView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var expiredView: UIView!
    
    @IBOutlet weak var inProgressStack: UIStackView!
    @IBOutlet weak var doneStack: UIStackView!
    @IBOutlet weak var expiredStack: UIStackView!
    
    var viewTapped: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameLabel.text = DBHelper.userInfo?.username
        
        
        for task in DBHelper.userTasks {
            print("\(task.title) \(task.dateBegin)")
            print("\(task.title) - \(task.dateBegin > Date())")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            switch touch.view {
            case inProgressView, inProgressStack:
                viewTapped = "active"
                performSegue(withIdentifier: K.homeSegue, sender: self)
            case doneView, doneStack:
                viewTapped = "done"
                performSegue(withIdentifier: K.homeSegue, sender: self)
            case expiredView, expiredStack:
                viewTapped = "expired"
                performSegue(withIdentifier: K.homeSegue, sender: self)
            default:
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TypeController
        destinationVC.type = viewTapped
        destinationVC.isFromHomeView = true
    }
    
}
