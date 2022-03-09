//
//  Habit.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/16/22.
//

import RealmSwift

class Habit : Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var title : String = ""
    @Persisted var dateCreate : Date = Date()
    @Persisted var daysCount : Int = 0
    
    @Persisted var reminders: List<Reminder>
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Habit.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func habitDaysCountUpdateAndNotif(createHabit: Date) -> Int {
        
        let habit = Habit()
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        formatter.dateFormat = "mm"
        let next21Days = calendar.date(byAdding: .minute, value: 22, to: createHabit)
        let diffInDays = Calendar.current.dateComponents([.minute], from: now, to: next21Days!).minute
        habit.daysCount = diffInDays!
        
        if diffInDays == 21 {
            let notificationCenter = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "\(self.title) Done"
            content.body = "You were able to finish a habit"
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print ("Error = errol local notification")
                }
            }
        }
        if diffInDays! >= 0 {
            return diffInDays!
        }else{
            return 0
        }
    }
}
