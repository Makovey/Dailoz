//
//  ProfileController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 24.12.2021.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var workView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var studyView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var allTypeView: UIView!
    
    @IBOutlet weak var workStack: UIStackView!
    @IBOutlet weak var homeStack: UIStackView!
    @IBOutlet weak var studyStack: UIStackView!
    @IBOutlet weak var otherStack: UIStackView!
    @IBOutlet weak var allStack: UIStackView!
    
    @IBOutlet weak var workTaskCountLabel: UILabel!
    @IBOutlet weak var homeTaskCountLabel: UILabel!
    @IBOutlet weak var studyTaskCountLabel: UILabel!
    @IBOutlet weak var otherTaskCountLabel: UILabel!
    @IBOutlet weak var allTaskCountLabel: UILabel!
    
    var typeTapped: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workTaskCountLabel.text = prepareTextByType("work")
        homeTaskCountLabel.text = prepareTextByType("home")
        studyTaskCountLabel.text = prepareTextByType("study")
        otherTaskCountLabel.text = prepareTextByType("other")
        allTaskCountLabel.text = prepareTextByType("all")
        
        guard let userInfo = DBHelper.userInfo else {
            fatalError("UserInfo not loaded")
        }
        
        usernameLabel.text = userInfo.username
        emailLabel.text = userInfo.email
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            switch touch.view {
            case workView, workStack:
                typeTapped = "work"
                performSegue(withIdentifier: K.profileSegue, sender: self)
            case homeView, homeStack:
                typeTapped = "home"
                performSegue(withIdentifier: K.profileSegue, sender: self)
            case studyView, studyStack:
                typeTapped = "study"
                performSegue(withIdentifier: K.profileSegue, sender: self)
            case otherView, otherStack:
                typeTapped = "other"
                performSegue(withIdentifier: K.profileSegue, sender: self)
            case allTypeView, allStack:
                typeTapped = "all"
                performSegue(withIdentifier: K.profileSegue, sender: self)
            default:
                return
            }
        }
    }
    
    func prepareTextByType(_ type: String) -> String {
        if type == "all" {
            return DBHelper.userTasks.count > 1 ? "\(DBHelper.userTasks.count) Tasks" : "\(DBHelper.userTasks.count) Task"
        }
        
        let tasks = DBHelper.userTasks.filter { $0.type == type }
        return tasks.count > 1 ? "\(tasks.count) Tasks" : "\(tasks.count) Task"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.profileSegue {
            let destinationVC = segue.destination as! TypeController
            destinationVC.type = typeTapped
        }
    }
    
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            let navigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
            
            DBHelper.userId = nil
        } catch {
            print("Error signing out cause: \(error)")
        }
    }
    
}
