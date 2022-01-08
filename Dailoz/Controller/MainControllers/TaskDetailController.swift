//
//  TaskDetailController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 05.01.2022.
//

import UIKit

class TaskDetailController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = task?.title
    }
    

}
