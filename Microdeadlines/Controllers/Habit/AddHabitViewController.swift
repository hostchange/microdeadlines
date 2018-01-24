//
//  AddHabitViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 1/24/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class AddHabitViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let realm = try! Realm()
    var taskNotificationToken: NotificationToken?
    
    fileprivate lazy var habit: Habit = {
        let habit = Habit()
        return habit
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HABIT")
        print(habit)
        tableView.reloadData()
    }
    
    func setUpTableView() {
        tableView.registerNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.AddHabitToAddTask {
            guard let addTaskViewController = segue.destination as? AddTaskViewController else { return }
            addTaskViewController.habit = habit
            return
        }
    }
    
    func createHabit() {
        guard let habitName = nameTextField.text, habitName != "" else { return }
        try! realm.write {
            habit.name = habitName
            realm.add(habit)
        }
    }
    
    @IBAction func doneButtonDidTouch(_ sender: UIBarButtonItem) {
        createHabit()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonDidTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddHabitViewController: UITableViewDelegate {
    
}

extension AddHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habit.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.TaskTableViewCell) as? TaskTableViewCell {
            let task = habit.tasks[indexPath.row]
            cell.configureCell(task: task)
            return cell
        }
        return TaskTableViewCell()
    }
}

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            
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
