//
//  TaskController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 12.12.2021.
//

import UIKit

class TaskController: UIViewController {
    
    @IBOutlet weak var todayTaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayTaskTableView.delegate = self
        todayTaskTableView.dataSource = self
        todayTaskTableView.register(UINib(nibName: K.Cell.taskCell, bundle: nil), forCellReuseIdentifier: K.Cell.taskCell)
        NotificationCenter.default.addObserver(self, selector: #selector(deletedTaskNotification), name: Notification.Name.cellDeleted, object: nil)
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todayTaskTableView.reloadData()
    }
    
    @objc func deletedTaskNotification() {
        todayTaskTableView.reloadData()
    }


}

extension TaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBHelper.getOnlyTodaysTask()?.count ?? 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.taskCell, for: indexPath) as! TaskCell

        if let safetyTasks = DBHelper.getOnlyTodaysTask() {
            let sortedByHourTasks = safetyTasks.sorted(by: {
                DateHelper.getHourAndMinutes(date: $0.startAt).hour! <= DateHelper.getHourAndMinutes(date: $1.startAt).hour! &&
                DateHelper.getHourAndMinutes(date: $0.startAt).minute! <= DateHelper.getHourAndMinutes(date: $1.startAt).minute!
            })
            
            let task = sortedByHourTasks[indexPath.row]
            
            cell.idOfTask = task.id
            cell.title.text = task.title
            cell.time.text = "\(task.startAt.get(.hour)):\(task.startAt.get(.minute)) - \(task.endTo.get(.hour)):\(task.endTo.get(.minute))"
            cell.verticalLineView.backgroundColor = [UIColor.purple, UIColor.brown, UIColor.brown, UIColor.green, UIColor.orange].randomElement()
            cell.descriptionLabel.text = task.description
            
            if !cell.removeButton.isEnabled {
                cell.removeButton.alpha = 1.0
                cell.removeButton.isEnabled = true
                cell.time.alpha = 1.0
            }
            
        } else {
            cell.title.text = "No task for today"
            cell.time.alpha = 0.0
            cell.verticalLineView.backgroundColor = .clear
            cell.removeButton.alpha = 0.0
            cell.removeButton.isEnabled = false
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped cell number \(indexPath.row).")

        todayTaskTableView.reloadData()
    }
    
}

// TODO zamenit' na KONST
extension Notification.Name {
    static let cellDeleted = Notification.Name("cellDeleted")
}
