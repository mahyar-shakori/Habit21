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
    dynamic var daysCountCircular = CircularProgressView()
    
    @Persisted var reminders: List<Reminder>
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Habit.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func habitDaysCountUpdate(createDate: Date) -> Int {
        
        let habit = Habit()
        let calendar = Calendar.current
        let now = Date()
        
        let next21Days = calendar.date(byAdding: .day, value: 22, to: createDate)
        let diffInDays = Calendar.current.dateComponents([.day], from: now, to: next21Days!).day
        habit.daysCount = diffInDays!
    
        if diffInDays! >= 0 {
            return diffInDays!
        }else{
            return 0
        }
    }
}
