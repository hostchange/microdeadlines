//
//  AddTaskViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyTimer

class AddTaskViewController: UIViewController {
    
    let realm = try! Realm()
    
    var habit = Habit()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
    }
    
    func setUpTextField() {
        nameTextField.delegate = self
    }

    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        let time = Int(round(slider.value))
        timeLabel.text = "\(time) MIN"
    }
    
    @IBAction func doneBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        createNewTask()
    }
    
    func createNewTask() {
        guard let taskName = nameTextField.text, taskName != "" else { return }
        let time = Int(round(slider.value))
        try! realm.write {
            let task = Task()
            task.name = taskName
            task.countDownTimeInMinutes = time
            habit.tasks.append(task)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            createNewTask()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersLimit = Constants.CharactersLimitation.TaskName
        let currentText = textField.text as! NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        return updatedText.characters.count <= charactersLimit
    }
}
