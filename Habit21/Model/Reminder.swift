//
//  Reminde.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/12/22.
//

import RealmSwift

class Reminder : Object {
    @Persisted(primaryKey: true) var _id: String = ""
    @Persisted var reminderTime : String = ""
    @Persisted var isOn : Bool?
}
