//
//  AddViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    
    
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var addHabitTextField: UITextField!
    @IBOutlet weak var daysCount: UISwitch!
    @IBOutlet weak var reminder: UISwitch!
    @IBOutlet weak var firstSeprator: UIView!
    @IBOutlet weak var addOutlet: UIView!
    @IBOutlet weak var addHeight: NSLayoutConstraint!
    @IBOutlet weak var secondSeprator: UIView!
    @IBOutlet weak var date: UIView!
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var delegate: HomeDelegate?
    var datePicker: UIDatePicker?
    var list = [Reminde]()
    var realm : Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(AddViewController.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        datePicker!.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker?.backgroundColor = UIColor.white
    
        self.save.isEnabled = false
        self.save.tintColor = UIColor.lightGray
        self.addHabitTextField.delegate = self
        
        realm = try! Realm()
        loadValues()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let habit = Habit()
        habit.habitt = addHabitTextField.text ?? ""
//        habit.reminds = List(collection: list)
    
        try! realm?.write {
            realm?.add(habit)
        }
        delegate?.reload()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
//    @IBAction func buttonNotif(_ sender: Any) {
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = "Reminder"
//        content.body = "Local"
//        content.sound = .default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
//        center.add(request) { error in
//            if error != nil {
//                print("Error = \(error?.localizedDescription ?? "error local notification")")
//            }
//        }
//    }
    
    @IBAction func daysCountSwitch(_ sender: Any) {
    }
    
    @IBAction func reminderSwitch(_ sender: Any) {
        if reminder.isOn{
            self.addHeight.constant = 40
            self.dateHeight.constant = 40
            self.tableViewHeight.constant = 370
            firstSeprator.isHidden = false
            addOutlet.isHidden = false
            secondSeprator.isHidden = false
            date.isHidden = false
        }else{
            self.addHeight.constant = 0
            self.dateHeight.constant = 0
            self.tableViewHeight.constant = 450
            firstSeprator.isHidden = true
            addOutlet.isHidden = true
            secondSeprator.isHidden = true
            date.isHidden = true
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        let reminde = Reminde()
        reminde.alarmIsOn = true
        reminde.remind = dateTextField.text ?? ""
        self.list.append(reminde)
        self.tableView.reloadData()
        
    
//        try! realm?.write {
//            realm?.add(reminde)
//        }
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func loadValues() {
        self.list = Array(try! Realm().objects(Reminde.self))
        self.tableView.reloadData()
    }
    
}

extension AddViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = addHabitTextField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if updatedText.count > 0 {
                self.save.isEnabled = true
                self.save.tintColor = UIColor.systemRed
            }
            else {
                self.save.isEnabled = false
                self.save.tintColor = UIColor.lightGray
            }
        }
        return true
    }
}

extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindeCell") as! RemindeTableViewCell
        cell.switch_.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        cell.config(self.list[indexPath.row])
        return cell
    }
    //delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
        self.tableView.reloadData()
            
        } else if editingStyle == .insert {
        }
    }
}
