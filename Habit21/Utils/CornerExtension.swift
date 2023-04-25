//
//  CornerRadiusViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/21/22.
//

import Foundation
import UIKit

//extension UIButton {
//    func addCorner(corner: CGFloat) {
//        self.layer.cornerRadius = corner
//    }
//}

extension UIView {
    func addCornerView(corner: CGFloat) {
        self.layer.cornerRadius = corner
    }
}

extension UITextField {
    func addCorner(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
}
