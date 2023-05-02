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
    @IBOutlet weak var habitDaysCountCircular: CircularProgressView!
    @IBOutlet weak var habitCellButton: UIButton!
    
    func config(_ habit: Habit) {
        self.habitTitleLabel.text = "\(habit.title)"
        self.habitDaysCountLabel.text = "\(habit.habitDaysCountUpdate(createDate: habit.dateCreate)) days left"
        
        let days = Float (22 - habit.habitDaysCountUpdate(createDate: habit.dateCreate))
        
        habitDaysCountCircular.trackColor = UIColor(named: "trackColor")!
        habitDaysCountCircular.progressColor = UIColor(named: "progressColor")!
        habitDaysCountCircular.setProgressWithAnimation(value: days/22, duration: 1)
    }
}
