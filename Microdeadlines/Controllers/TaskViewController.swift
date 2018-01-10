//
//  TaskViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate lazy var tasks: Results<Task> =  {
        let sortProperties = [SortDescriptor(keyPath: "creationDate", ascending: false)]
        return self.realm.objects(Task.self).sorted(by: sortProperties)
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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpTaskNotification() {
        taskNotificationToken = tasks.observe { [weak self] changes in
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
                realm.add(task2)
                
                let task1 = Task()
                task1.countDownTimeInMinutes = 25
                task1.name = "WORK"
                task1.creationDate = Date()
                task1.numberOfTimesCompleted = 0
                realm.add(task1)
                
            }
            return
        }
        print("NOT FIRST TIME LAUNCH")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.TaskToTaskProgress {
            if let taskProgressViewController = segue.destination as? TaskProgressViewController {
                guard let selectedTask = selectedTask else { return }
                taskProgressViewController.task = selectedTask
            }
        }
    }

    @IBAction func addTaskButtonItemDidTouch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Segues.TaskToAddTask, sender: nil)
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let task = Array(tasks)[indexPath.row]
        try! realm.write {
            realm.delete(task)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        selectedTask = task
        performSegue(withIdentifier: Constants.Segues.TaskToTaskProgress, sender: nil)
    }
}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.TaskTableViewCell, for: indexPath) as? TaskTableViewCell {
            let task = tasks[indexPath.row]
            cell.configureCell(task: task)
            return cell
        }
        return TaskTableViewCell()
    }
    
}


