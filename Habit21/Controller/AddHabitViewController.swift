//
//  AddViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//

import UIKit
import RealmSwift
import UserNotifications

protocol AddHabitDelegate{
    func reload()
    func switchChanged(forItem item : Reminder)
}

class AddHabitViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var habitTitleTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var firstSeprator: UIView!
    @IBOutlet weak var addReminderView: UIView!
    @IBOutlet weak var addReminderButton: UIButton!
    @IBOutlet weak var addHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondSeprator: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderTableView: UITableView!
    
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
                
        hanleView()
    }
    
    func hanleView() {
        
        saveButton.isEnabled = false
        saveButton.tintColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 0.5)
        habitTitleTextField.delegate = self
        reminderSwitch.isEnabled = false
        reminderSwitch.isOn = false
        addReminderButton.tintColor = UIColor.label.withAlphaComponent(0.3)
        addHeightConstraint.constant = 0
        dateHeightConstraint.constant = 0
        reminderTableViewHeightConstraint.constant = 450
        reminderTableView.isHidden = true
        firstSeprator.isHidden = true
        secondSeprator.isHidden = true
        addReminderView.isHidden = true
        dateView.isHidden = true
        habitTitleTextField.placeholderColor = UIColor.lightGray
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(AddHabitViewController.reminderFormattedDate(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        datePicker!.preferredDatePickerStyle = UIDatePickerStyle.wheels
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        realm = try! Realm()
        
        loadValues()
 
        switch traitCollection.userInterfaceStyle {
        case .dark: dateTextField.placeholderColor = UIColor.white
            break
        case .light: dateTextField.placeholderColor = UIColor.black
            break
        default:
            print("Something else")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        habit.title = habitTitleTextField.text ?? ""
        habit.id = habit.incrementID()

        habit.reminders = List<Reminder>()
        
        try! realm?.write {
            realm?.add(habit)
        }
        delegate?.reload()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
     
//        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        removeNotification(identifier: reminder.id)

        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if dateTextField.text?.isEmpty == true {
            
            let alertController = UIAlertController(title: "First, Please pick a date", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            addReminderButton.tintColor = UIColor.label.withAlphaComponent(0.3)
            
            reminder.reminderTime = dateTextField.text ?? ""
            reminder.isOn = true
            reminder.id = ""
            
            reminderList.append(reminder)
            reminderTableView.reloadData()
            dismissKeyboard()
            dateTextField.text = nil
            
            formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
            notification(identifier: formatter.string(from: reminder.dateCreate), title: "Reminder", message: "You're trying to improve your lifestyle!, don't forget \(habitTitleTextField.text ?? "").", date: datePicker!.date)
            
            print("\(formatter.string(from: reminder.dateCreate))")
        }
    }
    
    @IBAction func reminderSwitchTapped(_ sender: Any) {
        if reminderSwitch.isOn{
            addHeightConstraint.constant = 40
            dateHeightConstraint.constant = 40
            reminderTableViewHeightConstraint.constant = 370
            reminderTableView.isHidden = false
            firstSeprator.isHidden = false
            secondSeprator.isHidden = false
            addReminderView.isHidden = false
            dateView.isHidden = false
        }else{
            addHeightConstraint.constant = 0
            dateHeightConstraint.constant = 0
            reminderTableViewHeightConstraint.constant = 450
            reminderTableView.isHidden = true
            firstSeprator.isHidden = true
            secondSeprator.isHidden = true
            addReminderView.isHidden = true
            dateView.isHidden = true
            notificationCenter.removeAllPendingNotificationRequests()
            notificationCenter.removeAllDeliveredNotifications()
            reminderList.removeAll()
            reminderTableView.reloadData()
        }
    }
    
    func notification(identifier: String, title: String, message: String, date: Date) {
        
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
    
    func switchChanged(forItem item: Reminder) {
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        if item.isOn == true{
            notification(identifier: formatter.string(from: reminder.dateCreate), title: habitTitleTextField.text ?? "Reminder", message: "You have to do it, Now!", date: (formatter.date(from: reminder.reminderTime) ?? now))
            print("\(String(describing: formatter.date(from: reminder.reminderTime)))")
        } else {
            removeNotification(identifier: formatter.string(from: item.dateCreate))
            print("Item \(item.dateCreate)'s switched has changed its value to \(String(describing: item.isOn))")
            print ("Item2 \(formatter.string(from: item.dateCreate))")
        }
    }
        
    @objc func reminderFormattedDate(datePicker: UIDatePicker) {
        formatter.dateFormat = "HH:mm"
        dateTextField.text = formatter.string(from: datePicker.date)
        addReminderButton.tintColor = UIColor.label.withAlphaComponent(1.0)
    }
    
    func notificationFormattedDate(date: Date) -> String {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

    func loadValues() {
        reminderList = Array(try! Realm().objects(Reminder.self))
        reminderTableView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

extension AddHabitViewController: AddHabitDelegate {
    func reload() {
    }
}

extension AddHabitViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == habitTitleTextField {
                if updatedText.isEmpty {
                    saveButton.isEnabled = false
                    saveButton.tintColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 0.5)
                    reminderSwitch.isEnabled = false
                    reminderSwitch.isOn = false
                    addHeightConstraint.constant = 0
                    dateHeightConstraint.constant = 0
                    reminderTableViewHeightConstraint.constant = 450
                    reminderTableView.isHidden = true
                    firstSeprator.isHidden = true
                    secondSeprator.isHidden = true
                    addReminderView.isHidden = true
                    dateView.isHidden = true
                    notificationCenter.removeAllPendingNotificationRequests()
                    notificationCenter.removeAllDeliveredNotifications()
                    reminderList.removeAll()
                    reminderTableView.reloadData()
                }
                else {
                    saveButton.isEnabled = true
                    saveButton.tintColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 1.0)
                    reminderSwitch.isEnabled = true
                }
            }
        }
        return true
    }
}

extension AddHabitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
        cell.config(reminderList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let reminder = reminderList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title:  "") { (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            
            let alert = UIAlertController(title: "Delete Reminder", message: "Are you sure you want to delete this reminder: \(reminder.reminderTime)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {  (alertAction) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(alertAction) in
                self.reminderList.remove(at: indexPath.row)
                self.reminderTableView.deleteRows(at: [indexPath], with: .fade)
                
                actionPerformed(true)
            }))
            self.present(alert, animated: true)
        }
        deleteAction.image = UIImage(named: "DeleteIcon")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
