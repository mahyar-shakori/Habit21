//
//  CornerRadiusViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/21/22.
//

import Foundation
import UIKit

extension UIView {
    func addCornerView(corner: CGFloat) {
        layer.cornerRadius = corner
    }
}

extension UITextField {
    func addCorner(corner: CGFloat) {
        layer.cornerRadius = corner
        layer.masksToBounds = true
    }
}
