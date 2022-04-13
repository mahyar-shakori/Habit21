//
//  EditViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/26/22.
//

import UIKit
import RealmSwift
import UserNotifications

protocol EditHabitDelegate {
    func switchChanged(forItem item : Reminder)
}

class EditHabitViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addHabitTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var firstSeprator: UIView!
    @IBOutlet weak var addHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondSeprator: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var reminderTableView: UITableView!
    @IBOutlet weak var reminderTableViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: HomeDelegate?
    var datePicker: UIDatePicker?
    let formatter = DateFormatter()
    let now = Date()
    let reminder = Reminder()
    var reminderList = [Reminder]()
    var habit = Habit()
    var realm : Realm?
    var notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHabitTextField.text = habit.title
        habit.reminders = List<Reminder>()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(AddHabitViewController.reminderFormattedDate(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        datePicker!.preferredDatePickerStyle = UIDatePickerStyle.wheels
            
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        realm = try! Realm()
        
        addHabitTextField.placeholderColor = UIColor.lightGray
        dateTextField.placeholderColor = UIColor.black
    
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let habit = Habit()

        habit.title = addHabitTextField.text ?? ""
//        habit.id = habit.incrementID()

        habit.reminders = List<Reminder>()
        
//        try! realm?.write {
//            realm?.add(habit, update: .modified)
//        }
        
        delegate?.reload()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func missedHabitButtonTapped(_ sender: Any) {
        let habit = Habit()

        let alert = UIAlertController(title: "Missed Habit", message: "Are you sure you want to reset 21days of this habit", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {  (alertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alertAction) in
            habit.daysCount = 21
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {

        if dateTextField.text?.isEmpty == true {

            let alertController = UIAlertController(title: "Please pick a date", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            reminder.reminderTime = dateTextField.text ?? ""
            reminder.isOn = true
            reminder.id = String(reminder.incrementID())

            self.reminderList.append(reminder)
            self.reminderTableView.reloadData()
            dismissKeyboard()
            self.dateTextField.text = nil

            addNotification(identifier: reminder.id, title: self.addHabitTextField.text ?? "Reminder", message: "You have to do it, Now!", date: self.datePicker!.date)
        }
    }
    
    @IBAction func reminderSwitchTapped(_ sender: Any) {
        if reminderSwitch.isOn{
            self.addHeightConstraint.constant = 40
            self.dateHeightConstraint.constant = 40
            self.reminderTableViewHeightConstraint.constant = 370
            self.reminderTableView.isHidden = false
            firstSeprator.isHidden = false
            secondSeprator.isHidden = false
            dateView.isHidden = false
        }else{
            self.addHeightConstraint.constant = 0
            self.dateHeightConstraint.constant = 0
            self.reminderTableViewHeightConstraint.constant = 450
            self.reminderTableView.isHidden = true
            firstSeprator.isHidden = true
            secondSeprator.isHidden = true
            dateView.isHidden = true
        }
    }
    
    func addNotification(identifier: String, title: String, message: String, date: Date) {
        
        notificationCenter.getNotificationSettings { (settings) in
            
            DispatchQueue.main.async
            {
                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = .default
                    
                    let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.notificationFormattedDate(date: date), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
                else
                {
                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default)
                    { (_) in
                        guard let setttingsURL = URL(string: UIApplication.openSettingsURLString)
                        else
                        {
                            return
                        }
                        
                        if(UIApplication.shared.canOpenURL(setttingsURL))
                        {
                            UIApplication.shared.open(setttingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
        
    }
    
    func removeNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
//    func switchChanged(forItem item: Reminder) {
//
//
//        removeNotification(identifier: reminder.id)
//    }
        
    @objc func reminderFormattedDate(datePicker: UIDatePicker) {
        formatter.dateFormat = "HH:mm"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    func notificationFormattedDate(date: Date) -> String
        {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

    func loadValues() {
//        self.reminderList = Array(try! Realm().objects(Reminder.self))
//        self.reminderTableView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    //az inja be bad chk she
}

extension EditHabitViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habit.reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
        cell.config(self.habit.reminders[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let reminder = self.reminderList[indexPath.row]
//        let deleteAction = UIContextualAction(style: .destructive, title:  "") { (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
//
//            let alert = UIAlertController(title: "Delete Reminder", message: "Are you sure you want to delete this reminder: \(reminder.reminderTime)?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {  (alertAction) in
//                actionPerformed(false)
//            }))
//
//            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alertAction) in
//                self.reminderList.remove(at: indexPath.row)
//                self.reminderTableView.deleteRows(at: [indexPath], with: .fade)
//
//                self.removeNotification(identifier: reminder.id)
//
//                actionPerformed(true)
//            }))
//            self.present(alert, animated: true)
//        }
//        deleteAction.image = UIImage(named: "DeleteIcon")
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let editAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
//        }
//        editAction.image = UIImage(named: "EditIcon")
//        editAction.backgroundColor = UIColor(named: "EditColor")
//        return UISwipeActionsConfiguration(actions: [editAction])
//    }
}