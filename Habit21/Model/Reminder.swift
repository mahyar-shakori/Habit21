//
//  Reminde.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/12/22.
//

import RealmSwift

class Reminder : Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var reminderTime : String = ""
    @Persisted var isOn : Bool?
    @Persisted var dateCreate : Date = Date()
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Reminder.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
