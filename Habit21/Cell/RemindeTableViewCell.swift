//
//  RemindeTableViewCell.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/12/22.
//

import UIKit

class RemindeTableViewCell: UITableViewCell {

    @IBOutlet weak var remindeLabel: UILabel!
    @IBOutlet weak var switch_: UISwitch!
    
    func config(_ reminde: Reminde) {
        self.remindeLabel.text = "\(reminde.remind)"
    self.switch_.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    @objc func switchChanged(){
        print("here")
        
    }
}
