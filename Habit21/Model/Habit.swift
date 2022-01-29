//
//  Habit.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/16/22.
//

import RealmSwift

class Habit : Object {
    @Persisted var habitt : String = ""
    
    @Persisted var reminds: List<Reminde>
}
