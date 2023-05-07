//
//  EditHabitViewController.swift
//  Habit21
//
//  Created by Mahyar on 4/19/23.
//

import UIKit
import RealmSwift

protocol EditHabitDelegate{
    func reload()
    func switchChanged(forItem item : Reminder)
}

class EditHabitViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editHabitTextField: UITextField!
    
    var delegate: HomeDelegate?
    var habit = Habit()
    var realm : Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        hanleView()
    }
    
    func hanleView() {
        self.saveButton.isEnabled = false
        saveButton.tintColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 0.5)
        self.editHabitTextField.delegate = self
        editHabitTextField.placeholderColor = UIColor.lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        realm = try! Realm()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        habit.title = editHabitTextField.text ?? ""
        habit.id = habit.incrementID()

        habit.reminders = List<Reminder>()
        
        try! realm?.write {
            realm?.add(habit)
        }
        delegate?.reload()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func missHabitButtonTapped(_ sender: Any) {
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

//extension EditHabitViewController: AddHabitDelegate {
//    func reload() {
//    }
//}

extension EditHabitViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == self.editHabitTextField {
                if updatedText.isEmpty {
                    self.saveButton.isEnabled = false
                    self.saveButton.tintColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 0.5)
                }
                else {
                    self.saveButton.isEnabled = true
                    self.saveButton.tintColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 1.0)
                }
            }
        }
        return true
    }
}
