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
    @IBOutlet weak var habitEditButton: UIButton!
    
    var dissmissButtonFlag = true
    let now = Date()
    
    func config(_ habit: Habit) {
        habitTitleLabel.text = "\(habit.title)"
        if dissmissButtonFlag == false {
            habitDaysCountLabel.text = "\(habit.habitDaysCountUpdate(createDate: now)) days left"
        } else {
            habitDaysCountLabel.text = "\(habit.habitDaysCountUpdate(createDate: habit.dateCreate)) days left"
        }
        
        
        let days = Float (22 - habit.habitDaysCountUpdate(createDate: habit.dateCreate))
        
        habitDaysCountCircular.trackColor = UIColor(named: "trackColor")!
        habitDaysCountCircular.progressColor = UIColor(named: "progressColor")!
        habitDaysCountCircular.setProgressWithAnimation(value: days/22, duration: 1)
    }
}
