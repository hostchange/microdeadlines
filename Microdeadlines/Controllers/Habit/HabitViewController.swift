//
//  TaskViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class HabitViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var habits: Results<Habit> =  {
        let sortProperties = [SortDescriptor(keyPath: "creationDate", ascending: false)]
        return self.realm.objects(Habit.self).sorted(by: sortProperties)
    }()
    
    var taskNotificationToken: NotificationToken?
    
    let realm = try! Realm()
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleFirstTimeAppLaunchIfNeeded()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpTaskNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        taskNotificationToken?.invalidate()
    }
    
    func setUpTableView() {
        tableView.registerNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpTaskNotification() {
        taskNotificationToken = habits.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            tableView.applyChanges(changes: changes)
        }
    }
    
    func handleFirstTimeAppLaunchIfNeeded() {
        let userDefaults = UserDefaults.standard
        guard let isFirstTimeAppLaunch = userDefaults.object(forKey: FIRST_TIME_APP_LAUNCH_KEY) as? Bool else {
            print("IS FIRST TIME LAUNCH")
            userDefaults.set(true, forKey: FIRST_TIME_APP_LAUNCH_KEY)
            userDefaults.synchronize()
            try! realm.write {
                
                let task2 = Task()
                task2.countDownTimeInMinutes = 5
                task2.name = "REST"
                task2.creationDate = Date()
                task2.numberOfTimesCompleted = 0
                
                let task1 = Task()
                task1.countDownTimeInMinutes = 25
                task1.name = "WORK"
                task1.creationDate = Date()
                task1.numberOfTimesCompleted = 0
                
                let habit = Habit()
                habit.creationDate = Date()
                habit.name = "Pomodoro Productivity"
                habit.tasks.append(task1)
                habit.tasks.append(task2)
                
                realm.add(habit)
            }
            return
        }
        print("NOT FIRST TIME LAUNCH")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let selectedTask = selectedTask
            else { return }
        
        switch identifier {
        case Constants.Segues.TaskToTaskProgress:
            guard let taskProgressViewController = segue.destination as? TaskProgressViewController else { return }
            taskProgressViewController.task = selectedTask
            return
        case Constants.Segues.HabitToEditHabit:
            guard let navigationController = segue.destination as? UINavigationController,
                let editHabitViewController = navigationController.topViewController as? EditTaskViewController else { return }
            editHabitViewController.task = selectedTask
            return
        default:
            return
        }
    }

    @IBAction func addTaskButtonItemDidTouch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Segues.HabitToAddHabit, sender: nil)
    }
}

extension HabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let habit = Array(habits)[indexPath.section]
        let task = habit.tasks[indexPath.row]
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            try! self.realm.write {
                self.realm.delete(task)
            }
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.selectedTask = task
            self.performSegue(withIdentifier: Constants.Segues.HabitToEditHabit, sender: nil)
        }
        
        edit.backgroundColor = UIColor.green

        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = Array(habits)[indexPath.section]
        let task = habit.tasks[indexPath.row]
        selectedTask = task
        performSegue(withIdentifier: Constants.Segues.TaskToTaskProgress, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(habits)[section].name
    }
    
}

extension HabitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(habits)[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.TaskTableViewCell, for: indexPath) as? TaskTableViewCell {
            let habit = Array(habits)[indexPath.section]
            let task = habit.tasks[indexPath.row]
            cell.configureCell(task: task)
            return cell
        }
        return TaskTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}


