//
//  Task.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class Task: Object {
    @objc dynamic var name = String()
    @objc dynamic var countDownTimeInMinutes = Int()
    @objc dynamic var creationDate = Date()
    @objc dynamic var numberOfTimesCompleted = 1
    @objc dynamic var numberOfTimesStarted = 1
    @objc dynamic var successRate:Int {
        if (numberOfTimesStarted == 0 && numberOfTimesCompleted == 0) {
            return 100
        }
        else if (numberOfTimesStarted > 0 && numberOfTimesCompleted > 0){
            return (100)*(numberOfTimesStarted / numberOfTimesCompleted )
        }
        else{
            return 100
        }
    }
    
//    func convertToTaskRealm() -> TaskRealm {
//
//    }
}

class TaskRealm:Object {
    
    func saveToDrive() {
        
    }
}
