//
//  GlobalFuncs.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-22.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

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



// Check position of user id in
func checkSelectedIdPositionInUserData(id: String) -> Int? {
    // starter value
    print("UserData")
    var checked: Int = 0
    var counter: Int = 0
    for user in users {
        print("UserId -----> \(String(describing: user.id)) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

func checkSelectedIdPositionInPlayer(id: String) -> Int? {
    // starter value
    print("PlayerData")
    var checked: Int = 0
    var counter: Int = 0
    for user in playerArray {
        print("UserId -----> \(String(describing: user.id)) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

// Check position of player id in
func checkSelectedIdPositionInTournamentData(id: String) -> Int? {
    // starter value
    print("Tournamentdata: ")
    var checked: Int = 0
    var counter: Int = 0
    for user in tournaments {
        print("UserId -----> \(user.id) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

// Check position of score id in
func checkSelectedIdPositionInScoreData(id: String) -> Int? {
    // starter value
    print("Tournamentdata: ")
    var checked: Int = 0
    var counter: Int = 0
    for user in scores {
        print("UserId -----> \(user.id) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

// Rounded button
func setRound(button: UIButton) {
    button.layer.cornerRadius = 10
}

// Check position of score id in
func checkSelectedIdPositionInGameData(id: String) -> Int? {
    // starter value
    print("id: \(id)")
    print("GameData: ")
    var checked: Int = 0
    var counter: Int = 0
    for user in games {
        print("UserId -----> \(user.id) ")
        if id == user.id {
            // Selected user
            checked = counter
            
        }
        counter += 1
    }
    
    return checked
}

func fetchFriends() {
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
    users.removeAll()
    
    // Value added
    databaseRef.child("Users/\(uid!)/Friends").queryOrderedByKey().observeSingleEvent(of: .value, with: {
        
        (snapshot) in
        
        print(snapshot)
        
        // Fetch friends
        if let dict = snapshot.value as? [String: AnyObject] {
            for each in dict {
                if each.value as? Bool == true {
                    fetchUser(userId: each.key, sender: "true")
                }
            }

        }
        

        
    }, withCancel: nil)
}

func fetchUser(userId: String, sender: String) {
    var databaseRef: DatabaseReference!
    databaseRef = Database.database().reference()
        friendRequest.removeAll()
    
    databaseRef.child("Users/\(userId)").queryOrderedByKey().observeSingleEvent(of: .value, with: {
        
        (snapshot) in
        print(snapshot)
        
        // Fetch user
        if let dictionary = snapshot.value as? [String: AnyObject] {
            
            if sender == "true" {
                let user = UserClass(dictionary: dictionary)
                user.id = snapshot.key
                users.append(user)
            }
            
        }
        
    }, withCancel: nil)
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







