//
//  LargeHabitsCell.swift
//  Microdeadlines
//
//  Created by Pushkar Sharma on 25/02/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class LargeHabitsCell: UITableViewCell {
    
    var leftLargeBlock: LargeHabitTextBlock!
    var rightLargeBlock: LargeHabitTextBlock!

    func configureCell(taskL: Task, taskR: Task) {
        leftLargeBlock.configureBlock(task: taskL)
        rightLargeBlock.configureBlock(task: taskR)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        leftLargeBlock = LargeHabitTextBlock()
        rightLargeBlock = LargeHabitTextBlock()
        
        
        self.addSubview(leftLargeBlock)
        self.addSubview(rightLargeBlock)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h = self.bounds.height
        let w = self.bounds.width
        let side = 0.85*h
        
        leftLargeBlock.frame = CGRect(x: 0, y: 0, width: side, height: side)
        leftLargeBlock.center = CGPoint(x: w/4, y: h/2)
        rightLargeBlock.frame = CGRect(x: 0, y: 0, width: side, height: side)
        rightLargeBlock.center = CGPoint(x: 3*w/4, y: h/2)
        
        leftLargeBlock.layoutSubviews()
        rightLargeBlock.layoutSubviews()
    }
    
}
