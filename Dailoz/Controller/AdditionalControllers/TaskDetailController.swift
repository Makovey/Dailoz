//
//  TaskDetailController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 05.01.2022.
//

import UIKit

class TaskDetailController: UIViewController {
    
    var currentTask: Task?
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet var updateTextFields: [UITextField]!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startAtTextField: UITextField!
    @IBOutlet weak var untilTextField: UITextField!
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
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    var timing = (start: Date(), end: Date())
    
    var typeOfTask: String?
    
    var isRemindChecked = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()

        dateTextField.delegate = self
        startAtTextField.delegate = self
        untilTextField.delegate = self
        descriptionTextField.delegate = self
        
        styleTextFields()
        
        Utilities.setUpDatePicker(datePicker)
        Utilities.setUpTimePicker(timePicker)
        
        setUpInitialData()
    }
    
    func setUpInitialData() {
        if let currentTask = currentTask {
            mainLabel.text = "Update".localize() + " \"\(currentTask.title)\""
            dateTextField.text = dateFormatter.string(from: currentTask.dateBegin)
            startAtTextField.text = timeFormatter.string(from: currentTask.startAt)
            untilTextField.text = timeFormatter.string(from: currentTask.until)
            descriptionTextField.text = currentTask.description ?? ""
            typeOfTask = currentTask.type ?? nil
            
            datePicker.date = currentTask.dateBegin
            timePicker.date = currentTask.startAt
            
            timing.start = currentTask.startAt
            timing.end = currentTask.until
            
            isRemindChecked = currentTask.isNeededRemind
        }

        if isRemindChecked {
            remainderCheckbox.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        } else {
            remainderCheckbox.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }
        
        initTypeButton()
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
    
    func initTypeButton() {
        if let type = currentTask?.type {
            switch type {
            case "work":
                Utilities.styleButton(typeWorkButton, borderWidth: 2.5, borderColor: K.Color.purpleTypeBirght)
            case "home":
                Utilities.styleButton(typeHomeButton, borderWidth: 2.5, borderColor: K.Color.greenTypeBright)
            case "study":
                Utilities.styleButton(typeStudyButton, borderWidth: 2.5, borderColor: K.Color.orangeTypeBright)
            case "other":
                Utilities.styleButton(typeOtherButton, borderWidth: 2.5, borderColor: K.Color.blueTypeBright)
            default:
                return
            }
        }
    }
    
    func discardAllButtonsExceptButton(_ sender: UIButton) {
        for button in typeButtons where button != sender {
            Utilities.styleButton(button, borderWidth: 0, borderColor: nil)
        }
    }
    
    func styleTextFields() {
        for textField in updateTextFields {
            Utilities.styleTextField(textField)
        }
    }

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        if let date = dateTextField.text, let startAt = startAtTextField.text, let until = untilTextField.text {
            if !date.isEmpty && !startAt.isEmpty && !until.isEmpty {
                
                if let currentTask = currentTask {
                    
                    let task = Task(id: currentTask.id,
                                    title: currentTask.title,
                                    dateBegin: datePicker.date,
                                    startAt: timing.start,
                                    until: timing.end,
                                    type: typeOfTask,
                                    description: descriptionTextField.text ?? "",
                                    isDone: currentTask.isDone,
                                    isNeededRemind: isRemindChecked)
                    
                    if currentTask == task {
                        Utilities.showBunner(
                            title: "Task has not changed".localize(),
                            subtitle: "Сhange anything before updating".localize(),
                            style: .info)
                    } else {
                        DBHelper.updateUserTask(updatableTask: task, data: [
                            K.FStore.Field.date: datePicker.date,
                            K.FStore.Field.start: datePicker.date,
                            K.FStore.Field.end: datePicker.date,
                            K.FStore.Field.description: datePicker.date,
                            K.FStore.Field.type: datePicker.date,
                            K.FStore.Field.isNeededRemind: isRemindChecked
                        ]) {
                            Utilities.showBunner(title: "Woohoo".localize(), subtitle: "Task updated".localize(), style: .success)
                        }
                        
                        if currentTask.isNeededRemind && !isRemindChecked {
                            Utilities.deleteNotificationById(currentTask.id)
                        } else {
                            Utilities.scheduleNotificationToTask(task, showBanner: false)
                        }
                    }
                }
            } else {	
                Utilities.showBunner(
                    title: "Oh, we can't update your task".localize(),
                    subtitle: "Please, fill all required fields".localize(),
                    style: .danger)
            }
        }
        
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

extension TaskDetailController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case descriptionTextField:
            view.endEditing(true)
        default: break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if datePicker.date.get(.day) > Date().get(.day) {
            timePicker.minimumDate = nil
        } else {
            timePicker.minimumDate = Date()
        }
        
        switch textField {
        case dateTextField:
            bindPicker(picker: datePicker, to: textField)
        case startAtTextField, untilTextField:
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
        case untilTextField:
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
        case untilTextField:
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
        self.untilTextField.text = timeFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
}
