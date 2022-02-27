//
//  ViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/22/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func removeNotification(identifier: String) {
        
//        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
//            var identifiers: [String] = []
//            for notification:UNNotificationRequest in notificationRequests {
//                identifiers.append(notification.identifier)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
//            }
//        }
    }

}
