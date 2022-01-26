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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var type: String?
    var selectedTask: Task?
    var isFromHomeView = false
    
    var displayedTasks: Set<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeLabel.text = type!.localize().capitalized
        
        typeTableView.delegate = self
        typeTableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.searchTextField.font = UIFont(name: K.mainFont, size: 16)
        
        typeTableView.register(UINib(nibName: K.Cell.taskCell, bundle: nil), forCellReuseIdentifier: K.Cell.taskCell)
        NotificationCenter.default.addObserver(self, selector: #selector(self.deletedDisplayTask(_:)), name: Notification.Name.deletetdTask, object: nil)
    }
    
    @objc func deletedDisplayTask(_ notification: Notification) {
        if let task = notification.userInfo?["DeletedTask"] as? Task {
            displayedTasks?.remove(task)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromHomeView {
            displayedTasks = DBHelper.getTasksByDonable(type!)
        } else {
            displayedTasks = DBHelper.getTasksByType(type!)
        }
        
        typeTableView.reloadData()
    }
    
}

extension TypeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfTask = 0
            
        countOfTask = displayedTasks?.count ?? 0
        
        if countOfTask != 0 {
            self.typeTableView.restore()
        } else {
            self.typeTableView.setImageWithMessage("There are no such tasks.".localize())
        }
        
        return countOfTask
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.taskCell, for: indexPath) as! TaskCell
 
        if let safetyTasks = displayedTasks {
            let sortedByHourTasks = safetyTasks.sorted(by: { $0.startAt.compare($1.startAt) == .orderedAscending })
            
            let task = sortedByHourTasks[indexPath.row]
            
            cell.idOfTask = task.id
            cell.title.text = task.title
            cell.time.text = "\(task.startAt.get(.hour)):\(task.startAt.get(.minute)) - \(task.until.get(.hour)):\(task.until.get(.minute))"
            cell.descriptionLabel.text = task.description
            
            if task.isDone {
                cell.doneImage.alpha = 1
            } else {
                cell.doneImage.alpha = 0
            }
            
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
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Swipable cells

extension TypeController {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedCell = tableView.cellForRow(at: indexPath) as! TaskCell
        
        if let safetySelectedTask = DBHelper.userTasks.filter({ $0.id == selectedCell.idOfTask }).first {
            selectedTask = safetySelectedTask
        } else {
            return UISwipeActionsConfiguration()
        }
        
        let deleteAction = TableViewUtils.createDeleteAction(task: selectedTask!, indexPath: indexPath, tableView: typeTableView)
        let updateAction = TableViewUtils.createUpdateAction(task: selectedTask!, tableView: typeTableView, viewController: self)
        let finishable = TableViewUtils.createDoneAction(task: selectedTask!, cell: selectedCell)
        
        var configuration: UISwipeActionsConfiguration
        
        if finishable.title == "Active" {
            configuration = UISwipeActionsConfiguration(actions: [deleteAction, finishable])
        } else {
            configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction, finishable])
        }
        
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskDetailController
        destinationVC.currentTask = selectedTask
    }
}

extension TypeController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search right here
        
        if let safetyFilteredTask = DBHelper.getTasksByType(type!) {
            
            displayedTasks = safetyFilteredTask.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            
            if searchText.isEmpty {
                if isFromHomeView {
                    displayedTasks = DBHelper.getTasksByDonable(type!)
                } else {
                    displayedTasks = DBHelper.getTasksByType(type!)
                }
            }
        }
        
        typeTableView.reloadData()
    }
}
