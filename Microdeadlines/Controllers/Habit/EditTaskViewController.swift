//
//  EditHabitViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 1/21/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    let realm = try! Realm()
    var task = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
    }
    
    func setUpTextField() {
        nameTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpView()
    }
    
    func setUpView() {
        nameTextField.text = task.name
        let time = task.countDownTimeInMinutes
        timeLabel.text = "\(time) MIN"
        slider.value = Float(time)
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        let time = Int(round(slider.value))
        timeLabel.text = "\(time) MIN"
    }
    
    @IBAction func cancelBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        finishEditingHabit()
    }
    
    func finishEditingHabit() {
        guard let taskName = nameTextField.text, taskName != "" else { return }
        let time = Int(round(slider.value))
        try! realm.write {
            task.name = taskName
            task.countDownTimeInMinutes = time
        }
        dismiss(animated: true, completion: nil)
    }

}

extension EditTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
//            createNewTask()
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
