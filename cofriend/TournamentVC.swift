//
//  TournamentVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class TournamentVC: UITableViewController {
    
    // MARK: Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpRefreshController()
        setViewLayout(view: self.view)
                
        nyTableView.delegate = self
        nyTableView.dataSource = self
        
        selectedTourCell = false
        
        //self.navigationController?.hidesBarsOnSwipe = true

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetchUser()
        fetchUserTournaments()
        //refreshData()
        
        animateTable(tableView: nyTableView)
    }
    

    
    // MARK: Declarations

    @IBOutlet var nyTableView: UITableView!
    var refreshController: UIRefreshControl = UIRefreshControl()
    
    // MARK: Segue

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifiersSegue.AddToAddTournamentScore.rawValue && sender as? String != "selectedCell"{
            selectedTourCell = false
        }
    }
    // MARK: Functions
    
    func setUpRefreshController() {
        refreshController.tintColor = UIColor.orange
        refreshController.backgroundColor = UIColor.darkGray
        refreshController.attributedTitle = NSAttributedString(string: "Updating table..", attributes: [NSForegroundColorAttributeName : refreshController.tintColor])
        refreshController.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            nyTableView.refreshControl = refreshController
        } else {
            nyTableView.addSubview(refreshController)
        }
    }
    
    func refreshData() {
        fetchUserTournaments()
        nyTableView.reloadData()
        refreshController.endRefreshing()
    }
    
    
    func animateTable(tableView: UITableView) {
        
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
    

    
    
    // MARK: Fetch data
    
    func fetchUserTournaments() {
        // Clear arrays
        tournaments.removeAll()
        //players.removeAll()
        
        // Current user id
        let uid = Auth.auth().currentUser?.uid
        
        // Fetch tournament from user
        Database.database().reference().child("Users/\(uid!)/Tournaments").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            print(snapshot)
            
            var snapArray = [String]()
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for each in dictionary {
                    if each.value as? Bool == true {
                        print("adding value")
                        snapArray.append(each.key)
                    } else {
                        print("Didn't add value")
                    }
                }
            }
            

 
            
            for each in snapArray {                
                self.fetchTournamentConnectedWithUserId(tourId: each)
                self.fetchUserConnectedToTournaments(userId: each)
            }
            
            
            
            
        }, withCancel: nil)
    }
    
    func fetchTournamentConnectedWithUserId(tourId: String) {
        
        // Single fetch the tournament that the user has access to
        Database.database().reference().child("Tournaments/\(tourId)").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            print(snapshot)
            
            // Fetch tournament
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let tournament = TournamentClass(dictionary: dictionary)
                
                // add tournament id
                tournament.id = snapshot.key
                print(tournament.id as Any)
                
                // add tournament to array
                tournaments.append(tournament)
                
            }
        }, withCancel: nil)
    }
    

    func fetchUserConnectedToTournaments(userId: String) {
        // Append players as well
        Database.database().reference().child("Players/Tournaments/\(userId)").observeSingleEvent(of: .value, with: {
            
            (snapshot: DataSnapshot!) in
            
            print(snapshot)
            
            var snapArray = [String]()
            if let snapValue = snapshot.value as? [String: AnyObject] {
                for each in snapValue {
                    if let val = each.value as? Bool {
                        if val == true {
                            snapArray.append(each.key)
                        }
                    }
                    
                }
            }

            var snapPlayer = [UserClass]()
            
            // fetch user data instead and add to array
            for eachSnap in snapArray {
                for each in users {
                    if each.id == eachSnap {
                        snapPlayer.append(each)
                    }
                }
            }
            
            // Must append current user since the user is not within "users"
            snapPlayer.append(currentUser)
            
            players.append(PlayerClass(tournamentId: userId, players: snapPlayer))
            
            //this will crash because of background thread, so lets use dispatch_async to fix
            DispatchQueue.main.async(execute: {
                self.animateTable(tableView: self.nyTableView)
            })
            
        }, withCancel: nil)
    }
    
    /*
    func fetchUser() {
        
        // Clear array
        users.removeAll()
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Users").queryOrderedByKey().observe(.childAdded, with: {
            
            (snapshot) in

            
            // Fetch user
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = UserClass(dictionary: dictionary)
                // add user id to UserClass
                user.id = snapshot.key
                print("userid -----> " + user.id!)
                users.append(user)
                
            }
            
        }, withCancel: nil)
    }*/
    
    func deleteTournament(id: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Tournaments").child("\(id)").removeValue()
        
        // Current user id
        let uid = Auth.auth().currentUser?.uid
        
        // Delete tournament from user as well
        databaseRef.child("Users/\(uid!)/Tournaments/\(id)").setValue(false)
        
        // deletePlayersConnectedToTournament
        databaseRef.child("Players").child("Tournaments").child("\(id)").removeValue()

        // deleteGamesConnectedToTournament
        databaseRef.child("Games").child("Tournaments").child("\(id)").removeValue()

        // deleteScoresConnectedToTournament
    }
    



    
    // MARK: - Table view data source
    
    //tells the table view how many sections to display.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.count
    }
    
    //only ask for the cells for rows that are being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.TournamentCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TournamentCell
        
        // Fetches the appropriate data for the data source layout.
        let tour = tournaments[indexPath.row]
        cell.name.text = tour.name
        
        for each in players {
            if each.tournamentId == tour.id {
                selectedPlayer.tournamentId = each.tournamentId
                selectedPlayer.players = each.players
            }
        }
        
        if let countingPlayers = selectedPlayer.players {
            cell.countingPlayer.text = String(countingPlayers.count)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let selectedTournament = tournaments[(indexPath as NSIndexPath).row]
            selectedTour = selectedTournament
            print(selectedTournament.name as Any)
        
        for each in players {
            if each.tournamentId == selectedTournament.id {
                selectedPlayer.tournamentId = each.tournamentId
                selectedPlayer.players = each.players
            }
        }
        
    }
    

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting..")
            
            // Delete the row from the data source
            if let id = tournaments[indexPath.row].id {
                if let selectedId = checkSelectedIdPositionInTournamentData(id: id) {
                    tournaments.remove(at: selectedId)
                    deleteTournament(id: id)
                } else {
                    print("Failing to delete..")
                }
            }

            
            // This code saves the array whenever an item is deleted.
            //saveTourData()
            nyTableView.reloadData()
        }
    }*/
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
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
        let selectedTournament = tournaments[(indexPath as NSIndexPath).row]
        selectedTour = selectedTournament
        
        // Check if player created the tournament or not
        if let id = selectedTournament.createdByUserId {
            if userCreatedTournament(id: id) == true {
                selectedTourCell = true
                
                // Perform segue to edit
                performSegue(withIdentifier: identifiersSegue.AddToAddTournamentScore.rawValue, sender: "selectedCell")
            }
        } else {
            // Alert that edit is not possible because user did not create tournament
            showAlert(title: "Edit mode not possible", message: "You are not the creator of this tournament", dismissButton: "Cancel", okButton: "Ok", sender: "Edit", indexPath: indexPath)
        }
    }
    
    func showAlert(title: String, message: String, dismissButton: String, okButton: String, sender: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            self.alertOkFunctions(sender: sender, indexPath: indexPath)
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            //self.alertDismissFunctions()
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func alertOkFunctions(sender: String, indexPath: IndexPath) {
        if sender == "Delete" {
            // Delete the row from the data source
            if let id = tournaments[indexPath.row].id {
                if let selectedId = checkSelectedIdPositionInTournamentData(id: id) {
                    tournaments.remove(at: selectedId)
                    deleteTournament(id: id)
                } else {
                    print("Failing to delete..")
                }
            }
            
            // This code saves the array whenever an item is deleted.
            refreshData()
        }
    }
    
    func userCreatedTournament(id: String) -> Bool {
        var checked = false
        if currentUser.id == id {
            checked = true
        }
        return checked
    }
    
    func deleteButton(indexPath: IndexPath) {
        showAlert(title: "Deleting", message: "Do you want to delete?", dismissButton: "Cancel", okButton: "Ok", sender: "Delete", indexPath: indexPath)

    }

}
