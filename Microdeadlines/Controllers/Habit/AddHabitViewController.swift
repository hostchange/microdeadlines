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
    
    let realm = try! Realm()
    
    fileprivate lazy var habits: Results<Habit> =  {
        let sortProperties = [SortDescriptor(keyPath: "creationDate", ascending: false)]
        return self.realm.objects(Habit.self).sorted(by: sortProperties)
    }()
    
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
