//
//  TaskController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 12.12.2021.
//

import UIKit

class TaskController: UIViewController {
    
    @IBOutlet weak var todayTaskTableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let datePicker = UIDatePicker()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .none
        return df
    }()
    
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        searchBar.searchTextField.font = UIFont(name: K.mainFont, size: 16)
        
        todayTaskTableView.delegate = self
        todayTaskTableView.dataSource = self
        
        searchBar.delegate = self
        
        dateTextField.delegate = self
        createDatePicker()
        
        todayTaskTableView.register(UINib(nibName: K.Cell.taskCell, bundle: nil), forCellReuseIdentifier: K.Cell.taskCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todayTaskTableView.reloadData()
    }
}

extension TaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfTaskToday = DBHelper.getOnlyTaskOfDay(datePicker.date)?.count
        
        if let _ = countOfTaskToday {
            self.todayTaskTableView.restore()
        } else {
            countOfTaskToday = 0
            self.todayTaskTableView.setImageWithMessage("You don’t have any schedule today.")
        }
        return countOfTaskToday!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.taskCell, for: indexPath) as! TaskCell
        
        if let safetyTasks = DBHelper.getOnlyTaskOfDay(datePicker.date) {
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

extension TaskController {
    
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
        
        let deleteAction = TableViewUtils.createDeleteAction(task: selectedTask!, indexPath: indexPath, tableView: todayTaskTableView)
        let updateAction = TableViewUtils.createUpdateAction(task: selectedTask!, tableView: todayTaskTableView, viewController: self)
        let finishable = TableViewUtils.createDoneAction(task: selectedTask!, cell: selectedCell)
        
        var configuration: UISwipeActionsConfiguration
        
        if selectedTask!.isDone {
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

// MARK: - Set UIDatePicker to Keyboard and work with it

extension TaskController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolbarToTextField(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dateUpdated()
        self.view.endEditing(true)
    }
    
    func createToolbarToTextField(_ textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateTextFieldDonePressed))
        
        doneBtn.tintColor = K.Color.mainPurple
        toolbar.setItems([flexButton ,doneBtn], animated: true)
        
        return toolbar
    }
    
    func createDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = K.Color.mainPurple
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateTextFieldDonePressed() {
        dateUpdated()
        self.view.endEditing(true)
    }
    
    func dateUpdated() {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        todayTaskTableView.reloadData()
    }
}

extension TaskController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search right here
    }
}
