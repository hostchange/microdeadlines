//
//  Extensions.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 1/24/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import RealmSwift

// UIViewController
extension UIViewController {
    func showOkActionAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Table View
extension UITableView {
    
    // Register Nib
    func registerNib(name: String = Constants.TableViewCellIdentifiers.TaskTableViewCell) {
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        let identifier = Constants.TableViewCellIdentifiers.TaskTableViewCell
        self.register(nib, forCellReuseIdentifier: identifier)
        self.sectionHeaderHeight = 50
        self.rowHeight = 100
    }
    
    // Realm
    func applyChanges<T>(changes: RealmCollectionChange<T>) {
        switch changes {
        case .initial: reloadData()
        case let .update(_, deletions, insertions, updates):
            let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
            beginUpdates()
            insertRows(at: insertions.map(fromRow), with: .automatic)
            reloadRows(at: updates.map(fromRow), with: .automatic)
            deleteRows(at: deletions.map(fromRow), with: .automatic)
            endUpdates()
        case let .error(error):
            fatalError("\(error)")
        }
    }
}
