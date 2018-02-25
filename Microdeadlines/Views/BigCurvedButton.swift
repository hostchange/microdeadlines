//
//  BigCurvedButton.swift
//  Microdeadlines
//
//  Created by Pushkar Sharma on 25/02/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import QuartzCore

class BigCurvedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 39/255, green: 179/255, blue: 96/255, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/4
    }

}
