//
//  Constants.swift
//  Microdeadlines
//
//  Created by Jayven Nhan on 12/10/17.
//  Copyright © 2017 Jayven Nhan. All rights reserved.
//

import UIKit

// Keys
let FIRST_TIME_APP_LAUNCH_KEY = "FIRST_TIME_APP_LAUNCH_KEY"

// MARK: Constants
struct Constants {
    
    // MARK: Segues
    struct Segues {
        // MARK: Authentication - Welcome
        static let TaskToAddTask = "TaskToAddTask"
        static let TaskToTaskProgress = "TaskToTaskProgress"
        static let HabitToEditHabit = "HabitToEditHabit"
    }
    
    // MARK: Collection View Cell Identifiers
    struct CollectionViewCellIdentifiers {
        static let TabCollectionViewCell = "TabCollectionViewCell"
        static let TimeCollectionViewCell = "TimeCollectionViewCell"
    }
    
    // MARK: Table View Cell Identifiers
    struct TableViewCellIdentifiers {
        static let TaskTableViewCell = "TaskTableViewCell"
    }
    
    // MARK: Collection Reusable View Identifiers
    struct CollectionReusableViewIdentifiers {
        static let DateHeaderReusableView = "DateHeaderReusableView"
        static let HeaderReusableView = "HeaderReusableView"
    }
    
    // MARK: Nib Name
    struct NibName {
        static let PhotoCollectionViewCell = "PhotoCollectionViewCell"
        static let DroneView = "DroneView"
    }
    
    // MARK: Collection View Cell Size
    struct TableViewCellSize {
        struct Time {
            static let Height: CGFloat = 120
        }
    }
    
    // MARK: Collection View Header Size
    struct CollectionViewHeaderSize {
        static let Height: CGFloat = 50
    }
    
    // MARK: Character Limitation
    struct CharactersLimitation {
        static let TaskName = 20
    }
}

