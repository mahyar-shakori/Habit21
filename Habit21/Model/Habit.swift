//
//  Habit.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/16/22.
//

import RealmSwift
import Foundation

class Habit : Object {
    @Persisted(primaryKey: true) var _id: String = ""
    @Persisted var habitTitle : String = ""
    @Persisted var dateCreate : Date = Date()
    
    @Persisted var reminders: List<Reminder>
}
