//
//  EditHabitViewController.swift
//  Habit21
//
//  Created by Mahyar on 4/19/23.
//

import UIKit
import RealmSwift

class EditHabitViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var editHabitTextField: UITextField!
    
    var delegate: HomeDelegate?
    var habit = Habit()
    var realm : Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        hanleView()
    }
    
    func hanleView() {
        
        continueButton.addCornerView(corner: 12.5)
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
        let habit = HabitTableViewCell()
        habit.dissmissButtonFlag = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

//extension EditHabitViewController: AddHabitDelegate {
//    func reload() {
//    }
//}
