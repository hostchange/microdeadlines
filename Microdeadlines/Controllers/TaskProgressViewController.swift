//
//  TaskProgressViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import MKRingProgressView
import Each
import SwiftyTimer
import AudioToolbox

class TaskProgressViewController: UIViewController {
    
    @IBOutlet weak var progressView: MKRingProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let timer = Each(1).seconds
    let shapeLayer = CAShapeLayer()
    var task: Task!
    
    var pulsatingLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    func setUpView() {
        navigationItem.title = task.name
        let color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        progressView.ringWidth = view.bounds.width * 0.08
        progressView.startColor = color
        progressView.endColor = color
        progressView.backgroundRingColor = .black
        progressView.progress = 1
        timeLabel.text = "\(task.countDownTimeInMinutes)\nMIN"
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.stop()
    }
    
    func startTimer() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
        
        let totalNumberOfCountDownSeconds = Double(task.countDownTimeInMinutes).minute.seconds
        var numberOfSecondsProgressed = Double(0).seconds
        let startDate = Date(timeIntervalSince1970: 0)
        let calendar = Calendar.current
        timer.perform(on: self) {
            let progress = 1 - (numberOfSecondsProgressed / totalNumberOfCountDownSeconds)
            print("PROGRESS:", progress)
            if progress <= 0 {
                return .stop
            }
            
            let minutes = Int(((totalNumberOfCountDownSeconds - numberOfSecondsProgressed)/60).rounded(.up)) - 1
            
            let date = Date(timeInterval: numberOfSecondsProgressed, since: startDate)
            let seconds = Int(59 - calendar.component(.second, from: date))
            let textInSeconds = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            DispatchQueue.main.async {
                self.timeLabel.text = "\(minutes):\n\(textInSeconds)"
                self.progressView.progress = progress
            }
            numberOfSecondsProgressed += Double(1).second
            
            return .continue
        }
    }
    
    @IBAction func startButtonDidTouch(_ sender: UIButton) {
        startButton.isEnabled = false
        startTimer()
    }
}
