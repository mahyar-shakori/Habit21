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
        self.habitTitleLabel.text = "\(habit.habitTitle)"
        self.habitDaysCountLabel.text = "\(habit.habitDaysCount) days left"
    }
}
