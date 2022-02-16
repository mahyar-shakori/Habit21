//
//  AnimationViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/23/22.
//

import UIKit

class AnimationViewController: UIViewController {

    let shape = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: 0 , endAngle: .pi * 2, clockwise: true)
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        trackShape.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackShape)
        
        let fillCirclePath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: 0 , endAngle: (.pi * 2)/2, clockwise: true)
        shape.path = fillCirclePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.blue.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
        
        let button = UIButton(frame: CGRect(x: 20, y: view.frame.size.height-70, width: view.frame.size.width-40, height: 50))
        view.addSubview(button)
        button.setTitle("Animate", for: .normal)
        button.addTarget(self, action: #selector(animateBtnTapped), for: .touchUpInside)
        button.backgroundColor = .systemGreen
    }
    
    @objc func animateBtnTapped() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
    }
}
