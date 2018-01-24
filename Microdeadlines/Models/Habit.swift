//
//  Habit.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 1/24/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class Habit: Object {
    @objc dynamic var name = String()
    @objc dynamic var creationDate = Date()
    @objc dynamic var numberOfTimesCompleted = 0
    var tasks = List<Task>()
}
