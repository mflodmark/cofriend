//
//  FriendsViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellId = "cellId"
        
        //setViewLayout(view: self.view)
        
        //self.navigationController?.hidesBarsOnSwipe = true

        myTableView.register(UserCell.self, forCellReuseIdentifier: cellId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // Reset array
        users = []
        fetchFriends()
    }
    

    
    // Declarations
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    // MARK: Functions
    
    func refreshData() {
        
    }
        
    func fetchFriends() {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
    
        // Value added
        if let userId = uid {
            databaseRef.child("Users/\(userId)/Friends").queryOrderedByKey().observe(.childAdded, with: {
                
                (snapshot) in
                
                print(snapshot)
                
                // Fetch friends
                
                if snapshot.value as? String == "ReceivedFriendRequest" {
                    for eachFriend in friendRequest {
                        if let friendName = eachFriend.name {
                            self.showAlert(title: "Friend request", message: "Do you want to be friends with \(friendName)", dismissButton: "No", okButton: "Yes", friend: eachFriend, key: snapshot.key)
                        }
                    }
                } else if snapshot.value as? Bool == true {
                    self.fetchUser(userId: snapshot.key, sender: "true")
                }
                
            }, withCancel: nil)
        }
        
        
        /*
        // Value changed
        databaseRef.child("Users/\(uid!)/Friends").queryOrderedByKey().observe(.childChanged, with: {
            
            (snapshot) in
            
            print(snapshot)
            
            // Fetch friends
            if snapshot.value as? Bool == true {
                self.fetchUser(userId: snapshot.key, sender: "true")
            }

        }, withCancel: nil)*/
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
                } else if sender == "ReceivedFriendRequest" {
                    let user = UserClass(dictionary: dictionary)
                    user.id = snapshot.key
                    friendRequest.append(user)
                }

                
                //this will crash because of background thread, so lets use dispatch_async to fix
                
                DispatchQueue.main.async(execute: {
                    self.animateTable(tableView: self.myTableView)
                })
                
            }
            
        }, withCancel: nil)
    }
    

    
    func animateTable(tableView: UITableView) {

        // load data
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
    
    
    // Actions
    
    // MARK: - Table view data source
    
    //tells the table view how many sections to display.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return addUserData.count
        return users.count
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.PlayerCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
        
        // Fetches the appropriate data for the data source layout.
        //let user = addUserData[indexPath.row]
        let user = users[indexPath.row]

        cell.myLabel.text = user.name
        
        if let profileImageUrl = user.profileImageUrl {
            cell.myImage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        
        // Cell status
        tableView.allowsMultipleSelection = true
        
        
        return cell
    }
    
    // MARK: Alert
    
    func alertOkFunctions(friend: UserClass, key: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()

        if let id = friend.id {
            databaseRef.child("Users/\(uid!)/Friends").updateChildValues([id:true])
            databaseRef.child("Users/\(id)/Friends").updateChildValues([uid!:true])
        
        }
        
        self.fetchUser(userId: key, sender: "ReceivedFriendRequest")
    }
    
    func alertDismissFunctions(friend: UserClass) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        if let id = friend.id {
            databaseRef.child("Users/\(uid!)/Friends").updateChildValues([id:false])
            databaseRef.child("Users/\(id)/Friends").updateChildValues([uid!:false])
        }
    }

    func showAlert(title: String, message: String, dismissButton: String, okButton: String, friend: UserClass, key: String) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            self.alertOkFunctions(friend: friend, key: key)
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            self.alertDismissFunctions(friend: friend)
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: Edit table view
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped")
            self.editButton(indexPath: indexPath)
        }
        edit.backgroundColor = editColor
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            self.deleteButton(indexPath: indexPath)
        }
        delete.backgroundColor = deleteColor
        
        return [delete, edit]
    }
    
    func editButton(indexPath: IndexPath) {
        let selectedUserInArray = users[(indexPath as NSIndexPath).row]
        selectedUser = selectedUserInArray
        
        // Check if player created the tournament or not
        if let id = selectedUser.createdByUserId {
            if userCreatedUser(id: id) == true {
                //selectedScoreCell = true
                
                // Perform segue to edit
                performSegue(withIdentifier: identifiersSegue.AddUser.rawValue, sender: "selectedCell")
            }
        } else {
            // Alert that edit is not possible because user did not create tournament
            showAlertForUser(title: "Edit mode not possible", message: "You are not the creator of this user", dismissButton: "Cancel", okButton: "Ok", sender: "Edit", indexPath: indexPath)
        }
    }
    
    func showAlertForUser(title: String, message: String, dismissButton: String, okButton: String, sender: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            self.alertOkFunctionsForUser(sender: sender, indexPath: indexPath)
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            //self.alertDismissFunctions()
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func alertOkFunctionsForUser(sender: String, indexPath: IndexPath) {
        if sender == "Delete" {
            // Delete the row from the data source
            if let selectedId = users[indexPath.row].id {
                if let id = checkSelectedIdPositionInUserData(id: selectedId) {
                    users.remove(at: id)
                    // FIXME: Delete/ set to false in database as well
                    //deleteScoresConnectedToTournament(id: selectedId)
                } else {
                    print("Failing to delete..")
                }
                
            }
            
            // This code saves the array whenever an item is deleted.
            refreshData()
        }
    }
    
    func userCreatedUser(id: String) -> Bool {
        var checked = false
        if currentUser.id == id {
            checked = true
        }
        return checked
    }
    
    func deleteButton(indexPath: IndexPath) {
        showAlertForUser(title: "Deleting", message: "Do you want to delete?", dismissButton: "Cancel", okButton: "Ok", sender: "Delete", indexPath: indexPath)
        
    }
    

    
}
