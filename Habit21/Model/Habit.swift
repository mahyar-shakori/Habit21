//
//  Habit.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/16/22.
//

import RealmSwift

class Habit : Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var habitTitle : String = ""
    @Persisted var dateCreate : Date = Date()
    
    @Persisted var reminders: List<Reminder>
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Habit.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
