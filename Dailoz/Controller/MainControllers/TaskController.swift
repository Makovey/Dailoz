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
    }

}

extension TaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBHelper.userTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = DBHelper.userTasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.taskCell, for: indexPath) as! TaskCell
        
        let currentTaskStart = DateHelper.getsHourAndMinutes(date: task.startAt)
        let currentTaskEnd = DateHelper.getsHourAndMinutes(date: task.endTo)
        
        cell.title.text = task.title
        cell.time.text = "\(currentTaskStart.hour!):\(currentTaskStart.minute!) - \(currentTaskEnd.hour!):\(currentTaskEnd.minute!)"
        cell.descriptionLabel.text = task.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped cell number \(indexPath.row).")
    }
    
}
