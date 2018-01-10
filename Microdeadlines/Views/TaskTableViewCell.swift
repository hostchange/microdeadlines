//
//  TaskTableViewCell.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    func configureCell(task: Task) {
        timeLabel.text = "\(task.countDownTimeInMinutes)\nMIN"
        taskNameLabel.text = task.name
    }
    
}
