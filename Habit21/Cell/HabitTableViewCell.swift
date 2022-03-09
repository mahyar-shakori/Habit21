//
//  HabitTableViewCell.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/16/22.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var habitDaysCountLabel: UILabel!
    
    func config(_ habit: Habit) {
        self.habitTitleLabel.text = "\(habit.title)"
        self.habitDaysCountLabel.text = "\(habit.habitDaysCountUpdateAndNotif(createHabit: habit.dateCreate)) days left"
    }
}
