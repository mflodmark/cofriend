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
        
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tournaments.removeAll()
        players.removeAll()
        users.removeAll()
        fetchUser()
        fetchUserTournaments()
        animateTable(tableView: nyTableView)
    }
    

    
    // MARK: Declarations

    @IBOutlet var nyTableView: UITableView!
    var refreshController: UIRefreshControl = UIRefreshControl()
    
    
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
    
    
    
    func fetchUserTournaments() {
        // Current user id
        let uid = Auth.auth().currentUser?.uid
        
        // Single fetch tournament from user
        Database.database().reference().child("Users").child(uid!).child("Tournaments").observe(.childAdded, with: {
            
            (snapshot) in
            
            print(snapshot)

            var snapArray = [String]()
            let snap = snapshot.value as! String
            print(snapArray.count)
            
            snapArray.append(snap)
            
            for each in snapArray {                
                self.fetchTournamentConnectedWithUserId(userId: each)
                self.fetchUserConnectedToTournaments(userId: each)
            }
            
        }, withCancel: nil)
    }
    
    func fetchTournamentConnectedWithUserId(userId: String) {
        
        // Single fetch the tournament that the user has access to
        Database.database().reference().child("Tournaments/\(userId)").observeSingleEvent(of: .value, with: {
            
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
            var snapPlayer = [UserClass]()
            if let snap = snapshot.value as? NSArray  {
                snapArray = snap as! [String]
            }
            print(snapArray.count)
            
            // fetch user data instead and add to array
            for eachSnap in snapArray {
                print("user count -----> \(users.count)")
                for each in users {
                    print(each.id!)
                    print(eachSnap)
                    if each.id == eachSnap {
                        print("each id = each snap")
                        snapPlayer.append(each)
                        //print(players.count as Any)
                        print("Each")
                        print(each.name as Any)
                        print(each.id as Any)
                        print(each.email as Any)
                        print(each.profileImageUrl as Any)
                        
                    }
                }
            }
            
            players.append(PlayerClass(tournamentId: userId, players: snapPlayer))
            
            
             //this will crash because of background thread, so lets use dispatch_async to fix
             DispatchQueue.main.async(execute: {
             self.animateTable(tableView: self.nyTableView)
             })
            
        }, withCancel: nil)
    }
    
    func fetchUser() {
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
    }
    
    func deleteTournament(id: String, index: Int) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Tournaments").child("\(id)").removeValue()
        
        // Current user id
        let uid = Auth.auth().currentUser?.uid
        
        // Delete tournament from user as well
        databaseRef.child("Users").child("\(uid!)").child("\(index)").removeValue()
        

    }
    
    func deletePlayersConnectedToTournament(id: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Players").child("Tournaments").child("\(id)").removeValue()
    }
    
    func deleteGamesConnectedToTournament(id: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Games").child("Tournaments").child("\(id)").removeValue()
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
            
    }
    

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting..")
            
            // Delete the row from the data source
            if let id = tournaments[indexPath.row].id {
                if let selectedId = checkSelectedIdPositionInTournamentData(id: id) {
                    tournaments.remove(at: selectedId)
                    deleteTournament(id: id, index: indexPath.row)
                    deletePlayersConnectedToTournament(id: id)
                    deleteGamesConnectedToTournament(id: id)
                } else {
                    print("Failing to delete..")
                }
            }

            
            // This code saves the array whenever an item is deleted.
            //saveTourData()
            nyTableView.reloadData()
        }
    }
    
    
}
