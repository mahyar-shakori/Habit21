//
//  Reminde.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/12/22.
//

import RealmSwift

class Reminder : Object {
    @Persisted(primaryKey: true) var id: String = ""
//    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var reminderTime : String = ""
    @Persisted var isOn : Bool?
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Habit.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
