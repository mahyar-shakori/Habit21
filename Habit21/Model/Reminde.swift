//
//  Reminde.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/12/22.
//

import RealmSwift

class Reminde : Object {
    @Persisted var remind : String = ""
    @Persisted var alarmIsOn : Bool = true
    
}
