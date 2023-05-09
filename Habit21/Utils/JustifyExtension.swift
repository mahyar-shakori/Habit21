//
//  File.swift
//  Habit21
//
//  Created by Mahyar on 5/9/23.
//

import Foundation
import UIKit

extension UILabel {
    
    func justifyLabel(str: String) -> NSAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        paragraphStyle.lineSpacing = 3
        let attributedString = NSAttributedString(string: str,
                                                  attributes: [
                                                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                    NSAttributedString.Key.baselineOffset: NSNumber(value: 0)
                                                  ])
        return attributedString
    }
}
