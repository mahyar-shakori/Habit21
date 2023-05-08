//
//  RemindeTableViewCell.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/12/22.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch?
    
    var delegate : AddHabitDelegate?
    var reminder : Reminder!
    
    func config(_ reminder: Reminder) {
        self.reminder = reminder
        
        reminderLabel.text = "\(reminder.reminderTime)"
        reminderSwitch?.isOn = reminder.isOn ?? true
        reminderSwitch?.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc func switchChanged() {
        reminder.isOn = reminderSwitch?.isOn
        delegate?.switchChanged(forItem: reminder)
    }
}
