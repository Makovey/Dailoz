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
    
    @IBOutlet var typeButtons: [UIButton]!
    @IBOutlet weak var typeWorkButton: UIButton!
    @IBOutlet weak var typeHomeButton: UIButton!
    @IBOutlet weak var typeStudyButton: UIButton!
    @IBOutlet weak var typeOtherButton: UIButton!
    
    @IBOutlet weak var remainderCheckbox: UIButton!
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = .current
        picker.minimumDate = Date()
        return picker
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = .current
        picker.minimumDate = Date()
        return picker
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.timeZone = .current
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    let notification = NotificationCenter.default
    
    var timing = (start: Date(), end: Date())
    
    var typeOfTask: String?
    
    var isRemindChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        titleTextField.delegate = self
        dateTextField.delegate = self
        startAtTextField.delegate = self
        endTextField.delegate = self
        descriptionTextField.delegate = self
        
        styleTextFields()
        
        Utilities.setUpDatePicker(datePicker)
        Utilities.setUpTimePicker(timePicker)
    }
    
    @IBAction func tagButtonPressed(_ sender: UIButton) {
        discardAllButtonsExceptButton(sender)
        
        switch sender {
        case typeWorkButton:
            if typeOfTask != "work" {
                Utilities.styleButton(typeWorkButton, borderWidth: 2.5, borderColor: K.Color.purpleTypeBirght)
                typeOfTask = "work"
            } else {
                Utilities.styleButton(typeWorkButton, borderWidth: 0, borderColor: nil)
                typeOfTask = nil
            }
        case typeHomeButton:
            if typeOfTask != "home" {
                Utilities.styleButton(typeHomeButton, borderWidth: 2.5, borderColor: K.Color.greenTypeBright)
                typeOfTask = "home"
            } else {
                Utilities.styleButton(typeHomeButton, borderWidth: 0, borderColor: nil)
                typeOfTask = nil
            }
        case typeStudyButton:
            if typeOfTask != "study" {
                Utilities.styleButton(typeStudyButton, borderWidth: 2.5, borderColor: K.Color.orangeTypeBright)
                typeOfTask = "study"
            } else {
                Utilities.styleButton(typeStudyButton, borderWidth: 0, borderColor: nil)
                typeOfTask = nil
            }
        case typeOtherButton:
            if typeOfTask != "other" {
                Utilities.styleButton(typeOtherButton, borderWidth: 2.5, borderColor: K.Color.blueTypeBright)
                typeOfTask = "other"
            } else {
                Utilities.styleButton(typeOtherButton, borderWidth: 0, borderColor: nil)
                typeOfTask = nil
            }
        default:
            fatalError("Unknown button")
        }
        
    }
    
    func discardAllButtonsExceptButton(_ sender: UIButton) {
        for button in typeButtons where button != sender {
            Utilities.styleButton(button, borderWidth: 0, borderColor: nil)
        }
    }
    
    func resetTypeButtons() {
        for button in typeButtons {
            Utilities.styleButton(button, borderWidth: 0, borderColor: nil)
        }
        typeOfTask = nil
    }
    
    func styleTextFields() {
        for textField in createTaskTextFields {
            Utilities.styleTextField(textField)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if let title = titleTextField.text, let date = dateTextField.text, let startAt = startAtTextField.text, let endTo = endTextField.text {
            if !title.isEmpty && !date.isEmpty && !startAt.isEmpty && !endTo.isEmpty {
                
                let task = Task(title: title,
                                dateBegin: datePicker.date,
                                startAt: timing.start,
                                until: timing.end,
                                type: typeOfTask,
                                description: descriptionTextField.text ?? "",
                                isNeededRemind: isRemindChecked)
                
                if checkAlreadyHasThisTask(task) {
                    Utilities.showBunner(title: "Oops".localize(), subtitle: "You're alredy planned".localize() + " \(task.title)", style: .warning)
                    return
                }
                
                DBHelper.saveDataToSubcollection(
                    collection: K.FStore.Collection.tasks,
                    subCollection: K.FStore.Collection.userTasks,
                    data: [
                        K.FStore.Field.id: task.id,
                        K.FStore.Field.title: task.title,
                        K.FStore.Field.date: task.dateBegin,
                        K.FStore.Field.start: task.startAt,
                        K.FStore.Field.end: task.until,
                        K.FStore.Field.type: task.type ?? "",
                        K.FStore.Field.description: task.description ?? "",
                        K.FStore.Field.isDone: task.isDone,
                        K.FStore.Field.isNeededRemind: task.isNeededRemind
                    ])
                
                DBHelper.userTasks.insert(task)
                Utilities.showBunner(title: "We're plained your task".localize(), subtitle: "\(task.title) - startAt \(startAt)", style: .success)
                Utilities.clearAllTextFields(textFields: self.createTaskTextFields)
                self.resetTypeButtons()
                
                if isRemindChecked {
                    Utilities.scheduleNotificationToTask(task, showBanner: false)
                }
                
            } else {
                Utilities.showBunner(
                    title: "Oh, we can't save your task".localize(),
                    subtitle: "Please, fill all required fields".localize(),
                    style: .danger)
            }
        }
    }
    
    func checkAlreadyHasThisTask(_ task: Task) -> Bool {
        var result = false
        
        let taskDate = DateHelper.getMonthAndDay(date: task.dateBegin)
        let taskStartTime = DateHelper.getHourAndMinutes(date: task.startAt)
        let taskEndTime = DateHelper.getHourAndMinutes(date: task.until)
        
        if !DBHelper.userTasks.isEmpty {
            for taskFromDB in DBHelper.userTasks where task.title == taskFromDB.title {
                let dbTaskDate = DateHelper.getMonthAndDay(date: taskFromDB.dateBegin)
                if taskDate.month! == dbTaskDate.month! && taskDate.day! == dbTaskDate.day! {
                    let dbTaskStartTime = DateHelper.getHourAndMinutes(date: taskFromDB.startAt)
                    let dbTaskEndTime = DateHelper.getHourAndMinutes(date: task.until)
                    if taskStartTime.hour == dbTaskStartTime.hour && taskStartTime.minute == dbTaskStartTime.minute {
                        if taskEndTime.hour == dbTaskEndTime.hour && taskEndTime.minute == dbTaskEndTime.minute {
                            result = true
                            break
                        }
                    }
                }
                
            }
        }
        return result
    }
    
    @IBAction func checkboxPressed(_ sender: UIButton) {
        if !isRemindChecked {
            remainderCheckbox.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        } else {
            remainderCheckbox.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }
        
        isRemindChecked = !isRemindChecked
    }
}

// MARK: - Set UIDatePicker to Keyboard and work with it

extension AddTaskController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleTextField:
            dateTextField.becomeFirstResponder()
        case descriptionTextField:
            view.endEditing(true)
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
    
    func bindPicker(picker: UIDatePicker, to textField: UITextField) {
        textField.inputView = picker
        textField.inputAccessoryView = createToolbarToTextField(textField)
    }
    
    func createToolbarToTextField(_ textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneBtn: UIBarButtonItem?
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
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
        toolbar.setItems([flexButton, safetyDoneBtn], animated: true)
        
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
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func inputTimeStartToTextField() {
        timing.start = timePicker.date
        self.startAtTextField.text = timeFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    func inputTimeEndToTextField() {
        timing.end = timePicker.date
        self.endTextField.text = timeFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
}
