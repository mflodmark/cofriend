//
//  GlobalFuncs.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-22.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

// Hide & Show

func hide(button: UIButton) {
    button.isHidden = true
}

func showField(button: UIButton) {
    button.isHidden = false
}

func hide(textField: UITextField) {
    textField.isHidden = true
}

func showField(textField: UITextField) {
    textField.isHidden = false
}

func hide(picker: UIPickerView) {
    picker.isHidden = true
}

func showField(picker: UIPickerView) {
    picker.isHidden = false
}


// Check position of id
func checkSelectedIdPositionInArray(id: Int) -> Int? {
    // starter value
    print("StoredData:")
    var checked = Int()
    var counter: Int = 0
    for user in addStoredData {
        print("UserId -----> \(user.id) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

// Check position of user id in
func checkSelectedIdPositionInUserData(id: Int) -> Int? {
    // starter value
    print("UserData")
    var checked = Int()
    var counter: Int = 0
    for user in addUserData {
        print("UserId -----> \(user.id) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

/*
// MARK: Refresh 

func setUpRefreshController(refreshController: UIRefreshControl, myTableView: UITableView, myView: UIView) {
    
    // Styling
    refreshController.tintColor = UIColor.orange
    refreshController.backgroundColor = UIColor.darkGray
    refreshController.attributedTitle = NSAttributedString(string: "Updating table..", attributes: [NSForegroundColorAttributeName : refreshController.tintColor])
    
    // Add target
    refreshController.addTarget(myView, action: #selector(refreshData(refreshController: refreshController, myTableView: myTableView)), for: UIControlEvents.valueChanged)
    
    if #available(iOS 10.0, *) {
        myTableView.refreshControl = refreshController
    } else {
        myTableView.addSubview(refreshController)
    }
}

func refreshData(refreshController: UIRefreshControl, myTableView: UITableView) {
    myTableView.reloadData()
    refreshController.endRefreshing()
}*/



