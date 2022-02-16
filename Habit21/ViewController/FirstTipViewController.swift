//
//  FirstTipViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/15/22.
//

import UIKit

class FirstTipViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var introduceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        introduceLabel.attributedText = justifyLabel(str: introduceLabel.text!)
    }
    
    func justifyLabel(str: String) -> NSAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        let attributedString = NSAttributedString(string: str,
                                                  attributes: [
                                                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                    NSAttributedString.Key.baselineOffset: NSNumber(value: 0)
            ])
        return attributedString
    }
}
