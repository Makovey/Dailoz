//
//  TypeController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 04.01.2022.
//

import UIKit

class TypeController: UIViewController {
    
    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeLabel.text = type!.capitalized
        
        typeTableView.delegate = self
        typeTableView.dataSource = self
        
        typeTableView.register(UINib(nibName: K.Cell.taskCell, bundle: nil), forCellReuseIdentifier: K.Cell.taskCell)
        NotificationCenter.default.addObserver(self, selector: #selector(deletedTaskNotification), name: Notification.Name.cellDeleted, object: nil)
    }
    
    @objc func deletedTaskNotification() {
        typeTableView.reloadData()
    }
    
}

extension TypeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBHelper.getTasksByType(type!)?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.taskCell, for: indexPath) as! TaskCell
        
        if let safetyTasks = DBHelper.getTasksByType(type!) {
            let sortedByHourTasks = safetyTasks.sorted(by: {
                Int($0.startAt.get(.hour))! <= Int($1.startAt.get(.hour))! &&
                Int($0.startAt.get(.minute))! <= Int($1.startAt.get(.minute))!
            })
            
            let task = sortedByHourTasks[indexPath.row]
            
            cell.idOfTask = task.id
            cell.title.text = task.title
            cell.time.text = "\(task.startAt.get(.hour)):\(task.startAt.get(.minute)) - \(task.endTo.get(.hour)):\(task.endTo.get(.minute))"
            cell.descriptionLabel.text = task.description
            
            switch task.type {
            case "work":
                cell.cellContent.backgroundColor = K.Color.purpleType
                cell.verticalLineView.backgroundColor = K.Color.purpleTypeBirght
                cell.typeLabel.text = "Work"
                cell.typeLabel.textColor = K.Color.purpleTypeBirght
            case "home":
                cell.cellContent.backgroundColor = K.Color.greenType
                cell.verticalLineView.backgroundColor = K.Color.greenTypeBright
                cell.typeLabel.text = "Home"
                cell.typeLabel.textColor = K.Color.greenTypeBright
            case "study":
                cell.cellContent.backgroundColor = K.Color.orangeType
                cell.verticalLineView.backgroundColor = K.Color.orangeTypeBright
                cell.typeLabel.text = "Study"
                cell.typeLabel.textColor = K.Color.orangeTypeBright
            case "other":
                cell.cellContent.backgroundColor = K.Color.blueType
                cell.verticalLineView.backgroundColor = K.Color.blueTypeBright
                cell.typeLabel.text = "Other"
                cell.typeLabel.textColor = K.Color.blueTypeBright
            default:
                cell.verticalLineView.backgroundColor = UIColor.black
                cell.cellContent.backgroundColor = K.Color.graphic
                cell.typeLabel.text = ""
            }
            
            if !cell.removeButton.isEnabled {
                cell.removeButton.alpha = 1.0
                cell.removeButton.isEnabled = true
                cell.time.alpha = 1.0
            }
            
        } else {
            cell.title.text = "No task in this category"
            cell.time.alpha = 0.0
            cell.verticalLineView.backgroundColor = .clear
            cell.cellContent.backgroundColor = K.Color.graphic
            cell.removeButton.alpha = 0.0
            cell.removeButton.isEnabled = false
            cell.typeLabel.text = ""
            cell.descriptionLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
