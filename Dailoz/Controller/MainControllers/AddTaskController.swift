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

    var timing = (start: Date(), end: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        dateTextField.delegate = self
        startAtTextField.delegate = self
        endTextField.delegate = self
        
        stylingTextFields()
        createDatePicker()
        createTimePicker()
    }
    
    
    func stylingTextFields() {
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
                
                DBHelper.saveDataToSubcollection(
                    collection: K.FStore.Collection.tasks,
                    documentName: DBHelper.userUid!,
                    subCollection: K.FStore.Collection.userTasks,
                    data: [
                        K.FStore.Field.title: title,
                        K.FStore.Field.date: datePicker.date,
                        K.FStore.Field.start: timing.start,
                        K.FStore.Field.end: timing.end,
                        K.FStore.Field.description: descriptionTextField.text ?? ""
                    ])
                
                Utilities.showBunner(title: "We're plained your task", subtitle: "\(title) - startAt \(startAt)", style: .success)
                Utilities.clearAllTextFields(textFields: createTaskTextFields)
                
            } else {
                Utilities.showBunner(title: "Oh, we can't save your task", subtitle: "Please, fill all required fields", style: .danger)
            }
        }
    }
}

// MARK: Set UIDatePicker to Keyboard and work with it

extension AddTaskController: UITextFieldDelegate {
    
    //TODO сделать проверку на конец времени (не может быть раньше начала) или перенос на следующую дату
    //TODO отменить сохранение одинаковых тасок (Alert)
    
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
