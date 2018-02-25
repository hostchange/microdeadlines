//
//  LargeHabitTextBlock.swift
//  Microdeadlines
//
//  Created by Pushkar Sharma on 25/02/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

class LargeHabitTextBlock: UIView {

    var timeLabel: UILabel!
    var taskNameLabel: UILabel!
    
    func configureBlock(task: Task) {
        let timeText = NSMutableAttributedString(string: "\(task.countDownTimeInMinutes)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 80)])
        timeText.append(NSMutableAttributedString(string: " MIN", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 21)]))
        
        timeLabel.attributedText = timeText
        taskNameLabel.text = task.name
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 45)
        
        timeLabel.textColor = Constants.Colors.greyishBlack
        taskNameLabel.textColor = Constants.Colors.greyishBlack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.borderColor = Constants.Colors.greyishBlack.cgColor
        self.layer.borderWidth = 10.0
        
        self.backgroundColor = UIColor.white
        
        self.timeLabel = UILabel()
        self.taskNameLabel = UILabel()
        
        self.timeLabel.textAlignment = .center
        self.taskNameLabel.textAlignment = .center
        
        self.addSubview(timeLabel)
        self.addSubview(taskNameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        
        self.taskNameLabel.frame = self.bounds.applying(CGAffineTransform(scaleX: 1, y: 0.5))
        self.timeLabel.frame = self.taskNameLabel.frame.applying(CGAffineTransform(translationX: 0, y: self.bounds.height / 2))
    }
    
}
