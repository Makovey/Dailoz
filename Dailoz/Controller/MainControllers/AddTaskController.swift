//
//  AddTaskController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 01.12.2021.
//

import UIKit
import Foundation

class AddTaskController: UIViewController {
    
    @IBOutlet var createTaskTextFields: [UITextField]!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startAtTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    let notification = NotificationCenter.default
    
    var timing = (start: Date(), end: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        dateTextField.delegate = self
        startAtTextField.delegate = self
        endTextField.delegate = self
        
        styleTextFields()
        createDatePicker()
        createTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("user has \(DBHelper.userTasks.count) tasks")
    }
    
    
    func styleTextFields() {
        for textField in createTaskTextFields {
            Utilities.styleTextField(textField)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        validateAndSaveTask()
    }
    
    func validateAndSaveTask() {
        if let title = titleTextField.text, let date = dateTextField.text, let startAt = startAtTextField.text, let endTo = endTextField.text {
            if !title.isEmpty && !date.isEmpty && !startAt.isEmpty && !endTo.isEmpty {
                
                let task = Task(title: title, dateBegin: datePicker.date, startAt: timing.start, endTo: timing.end, description: descriptionTextField.text ?? "")
                
                if checkAlreadyHasThisTask(task) {
                    Utilities.showBunner(title: "Oops", subtitle: "You're alredy planned \(task.title)", style: .warning)
                    return
                }
                
                DBHelper.saveDataToSubcollection(
                    collection: K.FStore.Collection.tasks,
                    documentName: DBHelper.userId!,
                    subCollection: K.FStore.Collection.userTasks,
                    data: [
                        K.FStore.Field.id: task.id,
                        K.FStore.Field.title: task.title,
                        K.FStore.Field.date: task.dateBegin,
                        K.FStore.Field.start: task.startAt,
                        K.FStore.Field.end: task.endTo,
                        K.FStore.Field.description: task.description ?? ""
                    ])
                
                Utilities.showBunner(title: "We're plained your task", subtitle: "\(task.title) - startAt \(startAt)", style: .success)
                Utilities.clearAllTextFields(textFields: createTaskTextFields)
                
            } else {
                Utilities.showBunner(title: "Oh, we can't save your task", subtitle: "Please, fill all required fields", style: .danger)
            }
        }
    }
    
    func checkAlreadyHasThisTask(_ task: Task) -> Bool {
        var result = false
        
        let taskDate = DateHelper.getMonthAndDay(date: task.dateBegin)
        let taskStartTime = DateHelper.getHourAndMinutes(date: task.startAt)
        let taskEndTime = DateHelper.getHourAndMinutes(date: task.endTo)
        
        if !DBHelper.userTasks.isEmpty {
            for taskFromDB in DBHelper.userTasks {
                if task.title == taskFromDB.title {
                    let dbTaskDate = DateHelper.getMonthAndDay(date: taskFromDB.dateBegin)
                    if taskDate.month! == dbTaskDate.month! && taskDate.day! == dbTaskDate.day! {
                        
                        let dbTaskStartTime = DateHelper.getHourAndMinutes(date: taskFromDB.startAt)
                        let dbTaskEndTime = DateHelper.getHourAndMinutes(date: task.endTo)
                        
                        if taskStartTime.hour == dbTaskStartTime.hour && taskStartTime.minute == dbTaskStartTime.minute {
                            if taskEndTime.hour == dbTaskEndTime.hour && taskEndTime.minute == dbTaskEndTime.minute {
                                result = true
                                break
                            }
                        }
                    }
                }
            }
        }
        return result
    }
}

// MARK: Set UIDatePicker to Keyboard and work with it

extension AddTaskController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleTextField:
            dateTextField.becomeFirstResponder()
        case descriptionTextField:
            validateAndSaveTask()
        default: break
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case dateTextField:
            bindPicker(picker: datePicker, to: textField)
        case startAtTextField, endTextField:
            bindPicker(picker: timePicker, to: textField)
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case dateTextField:
            inputDateToTextField()
        case startAtTextField:
            inputTimeStartToTextField()
        case endTextField:
            inputTimeEndToTextField()
        default: break
        }
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
    }
    
    func createTimePicker() {
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = .white
        timePicker.timeZone = .autoupdatingCurrent
        timePicker.tintColor = K.Color.mainPurple
    }
    
    
    func bindPicker(picker: UIDatePicker,to textField: UITextField) {
        textField.inputView = picker
        textField.inputAccessoryView = createToolbarToTextField(textField)
    }
    
    func createToolbarToTextField(_ textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn: UIBarButtonItem?
        
        switch textField {
        case dateTextField:
            doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateTextFieldDonePressed))
        case startAtTextField:
            doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTextFieldDonePressed))
        case endTextField:
            doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTextFieldDonePressed))
        default:
            doneBtn = nil
        }
        
        guard let safetyDoneBtn = doneBtn else {
            fatalError("Toolbar's button is nil")
        }
        
        safetyDoneBtn.tintColor = K.Color.mainPurple
        toolbar.setItems([safetyDoneBtn], animated: true)
        
        return toolbar
    }
    
    @objc func dateTextFieldDonePressed() {
        inputDateToTextField()
    }
    
    @objc func startTextFieldDonePressed() {
        inputTimeStartToTextField()
    }
    
    @objc func endTextFieldDonePressed() {
        inputTimeEndToTextField()
    }
    
    func inputDateToTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func inputTimeStartToTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        
        timing.start = timePicker.date
        self.startAtTextField.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    func inputTimeEndToTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        timing.end = timePicker.date
        self.endTextField.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
}
