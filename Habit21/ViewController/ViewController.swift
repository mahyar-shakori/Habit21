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
//    
//    func removeNotification(identifier: String) {
//        
////        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
////            var identifiers: [String] = []
////            for notification:UNNotificationRequest in notificationRequests {
////                identifiers.append(notification.identifier)
//                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
////            }
////        }
//    }
//    static func removeReminderNotification(reminder: Reminder){
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [(reminder.id?.uuidString)!])
//        notificationCenter.removeDeliveredNotifications(withIdentifiers: [(reminder.id?.uuidString)!])
//    }
}


//print("Item \(item.dateCreate)'s switched has changed its value to \(item.isOn)")


//if diffInDays == 20 {
//            addNotification(identifier: UUID().uuidString, title: "\(self.habit.habitTitle) Done" , message: "You were able to finish a habit", date: now)
//        }
