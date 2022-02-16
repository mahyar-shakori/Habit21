//
//  SecondTipViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/15/22.
//

import UIKit

class SecondTipViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var throwLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        throwLabel.attributedText = justifyLabel(str: throwLabel.text!)
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
