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
    
    let datePicker = UIDatePicker()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .none
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        todayTaskTableView.delegate = self
        todayTaskTableView.dataSource = self
        
        dateTextField.delegate = self
        createDatePicker()
        
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
        return DBHelper.getOnlyTaskOfDay(datePicker.date)?.count ?? 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.taskCell, for: indexPath) as! TaskCell

        if let safetyTasks = DBHelper.getOnlyTaskOfDay(datePicker.date) {
            let sortedByHourTasks = safetyTasks.sorted(by: {
                DateHelper.getHourAndMinutes(date: $0.startAt).hour! <= DateHelper.getHourAndMinutes(date: $1.startAt).hour! &&
                DateHelper.getHourAndMinutes(date: $0.startAt).minute! <= DateHelper.getHourAndMinutes(date: $1.startAt).minute!
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
            cell.title.text = "No task for today"
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
