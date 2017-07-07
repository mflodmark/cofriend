//
//  GamesTVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class GamesTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setUpRefreshController()
        setViewLayout(view: self.view)
        
        navigationItem.title = selectedTour.name
        
        myTableView.delegate = self
        myTableView.dataSource = self
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchGamesId()
        refreshData()
        animateTable(tableView: myTableView)
        
    }
    
    @IBOutlet var myTableView: UITableView!
    
    var myArray = games
    var gameTitle = String()
    var refreshController: UIRefreshControl = UIRefreshControl()

    
    // MARK: Functions
    
    func setUpRefreshController() {
        refreshController.tintColor = UIColor.orange
        refreshController.backgroundColor = UIColor.darkGray
        refreshController.attributedTitle = NSAttributedString(string: "Updating table..", attributes: [NSForegroundColorAttributeName : refreshController.tintColor])
        refreshController.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            myTableView.refreshControl = refreshController
        } else {
            myTableView.addSubview(refreshController)
        }
    }
    
    func refreshData() {
        games.removeAll()
        fetchGamesId()
        myTableView.reloadData()
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
    
    func fetchGamesId() {
        // Clear array
        games.removeAll()
        myArray.removeAll()
        
        // Fetch game ids
        if let selectedId = selectedTour.id {
            Database.database().reference().child("Games/Tournaments/\(selectedId)").observe(.childAdded, with: {
                
                (snapshot) in
                
                print(snapshot)
                
                var snapArray: [String] = []
                snapArray.append(snapshot.key)
                
                /*
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for each in dictionary {
                        snapArray.append(each.key)
                    }
                }*/
                
         
                for each in snapArray {
                    self.fetchTournamentGames(gameId: each)
                }
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                
                 DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                 })
                
            }, withCancel: nil)
        }
    }
    
    
    func fetchTournamentGames(gameId: String) {
        //  Fetch
        if let selectedId = selectedTour.id {
            Database.database().reference().child("Games").child("Tournaments").child("\(selectedId)").child("\(gameId)").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
                
                print(snapshot)
            
            
                // Fetch games
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let game = GameClass(dictionary: dictionary)
                    
                    // add game id
                    game.id = snapshot.key
                    game.tournamentId = selectedId
                    
                    // add game to array
                    games.append(game)
                    
                }
                
                self.myArray = games
                
                
                DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                })
                
            }, withCancel: nil)
        }
    }
    
    func deleteGameConnectedToTournament(id: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Games/Tournaments/\(selectedTour.id!)/\(id)").removeValue()
        databaseRef.child("Players/Games/\(id)").removeValue()
        databaseRef.child("Scores/Games/\(id)").removeValue()


    }
    
    
    // MARK: - Table view data source
    
    //tells the table view how many sections to display.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    //only ask for the cells for rows that are being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.AddGamesCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddGameCell
        
        // Fetches the appropriate data for the data source layout.
        let game = myArray[indexPath.row]
        cell.myLabel.text = game.name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGame = myArray[(indexPath as NSIndexPath).row]
        selectedGame = selectGame

    }

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting..")
            
            // Delete the row from the data source
            if let gamesId = myArray[indexPath.row].id {
                if let id = checkSelectedIdPositionInGameData(id: gamesId) {
                    games.remove(at: id)
                    deleteGameConnectedToTournament(id: gamesId)
                    } else {
                    print("Failing to delete..")
                }
            }

            
            // This code saves the array whenever an item is deleted.
            myTableView.reloadData()
        }
    }*/
    
    // MARK: Edit table view
    
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
        let selectedGameInArray = games[(indexPath as NSIndexPath).row]
        selectedGame = selectedGameInArray
        
        // Check if player created the tournament or not
        if let id = selectedGame.createdByUserId {
            if userCreatedGame(id: id) == true {
                selectedGameCell = true
                
                // Perform segue to edit
                performSegue(withIdentifier: identifiersSegue.AddGame.rawValue, sender: "selectedCell")
            }
        } else {
            // Alert that edit is not possible because user did not create tournament
            showAlert(title: "Edit mode not possible", message: "You are not the creator of this game", dismissButton: "Cancel", okButton: "Ok", sender: "Edit", indexPath: indexPath)
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
            if let gamesId = myArray[indexPath.row].id {
                if let id = checkSelectedIdPositionInGameData(id: gamesId) {
                    games.remove(at: id)
                    deleteGameConnectedToTournament(id: gamesId)
                } else {
                    print("Failing to delete..")
                }
            }
            
            // This code saves the array whenever an item is deleted.
            refreshData()
        }
    }
    
    func userCreatedGame(id: String) -> Bool {
        var checked = false
        if currentUser.id == id {
            checked = true
        }
        return checked
    }
    
    func deleteButton(indexPath: IndexPath) {
        showAlert(title: "Deleting", message: "Do you want to delete?", dismissButton: "Cancel", okButton: "Ok", sender: "Delete", indexPath: indexPath)
        
    }
    
    // MARK: Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifiersSegue.AddGame.rawValue && sender as? String != "selectedCell"{
            selectedGameCell = false
        }
    }

    
}
