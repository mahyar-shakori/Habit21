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
      
        self.reminderLabel.text = "\(reminder.reminderTime)"
        self.reminderSwitch?.isOn = reminder.isOn ?? true
        self.reminderSwitch?.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc func switchChanged() {
        self.reminder.isOn = reminderSwitch?.isOn
        self.delegate?.switchChanged(forItem: self.reminder)
    }
}
