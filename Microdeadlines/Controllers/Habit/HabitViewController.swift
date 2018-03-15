//
//  TaskViewController.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

class HabitViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var habits: Results<Habit> =  {
        let sortProperties = [SortDescriptor(keyPath: "creationDate", ascending: true)]
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
        tableView.register(LargeHabitsCell.self, forCellReuseIdentifier: Constants.TableViewCellIdentifiers.LargeHabitsCell)
        
        let btnWidth = self.view.frame.width*0.85
        let origin = (self.view.frame.width - btnWidth)/2
        let btnHeight: CGFloat = 44
        let newHabitButton = BigCurvedButton(frame: CGRect(x: origin, y: 0, width: btnWidth, height: btnHeight))
        newHabitButton.addTarget(self, action: #selector(self.addHabit), for: .touchUpInside)
        newHabitButton.setTitle("+ new habit", for: .normal)
        let footerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: btnHeight)))
        footerView.addSubview(newHabitButton)
        tableView.tableFooterView = footerView
        
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

    @objc func addHabit() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "addTaskView") as? AddTaskViewController {
            vc.habit = self.habits.first!
            self.show(vc, sender: nil)
        }
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
        if indexPath.row > 0 {
            let habit = Array(habits)[indexPath.section]
            let task = habit.tasks[indexPath.row + 1]
            selectedTask = task
            performSegue(withIdentifier: Constants.Segues.TaskToTaskProgress, sender: nil)
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return Array(habits)[section].name
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 200 : 100
    }
    
}

extension HabitViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(habits)[section].tasks.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > 0, let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.TaskTableViewCell, for: indexPath) as? TaskTableViewCell {
            let habit = Array(habits)[indexPath.section]
            let task = habit.tasks[indexPath.row + 1]
            cell.configureCell(task: task)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.LargeHabitsCell, for: indexPath) as? LargeHabitsCell {
            let habit = Array(habits)[indexPath.section]
            let taskL = habit.tasks[indexPath.row]
            let taskR = habit.tasks[indexPath.row + 1]
            cell.configureCell(taskL: taskL, taskR: taskR)
            cell.leftLargeBlock.addTarget(self, action: #selector(self.taskSelected), for: .touchUpInside)
            cell.leftLargeBlock.tag = indexPath.row
            cell.rightLargeBlock.addTarget(self, action: #selector(self.taskSelected), for: .touchUpInside)
            cell.rightLargeBlock.tag = indexPath.row + 1
            return cell
        }
        return TaskTableViewCell()
    }
    
    @objc func taskSelected(sender: UIButton) {
        let habit = Array(habits)[0]
        let task = habit.tasks[sender.tag]
        selectedTask = task
        performSegue(withIdentifier: Constants.Segues.TaskToTaskProgress, sender: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
}


