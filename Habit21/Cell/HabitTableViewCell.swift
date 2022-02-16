//
//  HabitTableViewCell.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/16/22.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var habitLabel: UILabel!
    
    func config(_ habit: Habit) {
        self.habitLabel.text = "\(habit.habitTitle)"
    }
}
