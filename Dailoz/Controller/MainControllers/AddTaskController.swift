//
//  AddTaskController.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 01.12.2021.
//

import UIKit

class AddTaskController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startAtTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboardWhenTappedOut()
        
        dateTextField.delegate = self
        startAtTextField.delegate = self
        endTextField.delegate = self
        
        stylingElements()
        createDatePicker()
        createTimePicker()
    }
    

    func stylingElements() {
        Utilities.styleTextField(titleTextField)
        Utilities.styleTextField(dateTextField)
        Utilities.styleTextField(startAtTextField)
        Utilities.styleTextField(endTextField)
        Utilities.styleTextField(descriptionTextField)
    }
    
}

// MARK: Set UIDatePicker to Keyboard and work with it

extension AddTaskController: UITextFieldDelegate {
    
    //TODO сделать проверку на конец времени (не может быть раньше начала) или перенос на следующую дату
    //TODO title required & Description is optional
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            bindPicker(picker: datePicker, to: textField)
        } else if textField == startAtTextField || textField == endTextField {
            bindPicker(picker: timePicker, to: textField)
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
        datePicker.tintColor = K.Colors.mainPurple
    }
    
    func createTimePicker() {
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = .white
        timePicker.tintColor = K.Colors.mainPurple
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
        
        safetyDoneBtn.tintColor = K.Colors.mainPurple
        toolbar.setItems([safetyDoneBtn], animated: true)
        
        return toolbar
    }
    
    @objc func dateTextFieldDonePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func startTextFieldDonePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        self.startAtTextField.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func endTextFieldDonePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        self.endTextField.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
}
