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

var selectedTour = TournamentClass(dictionary: ["" : "" as AnyObject])
var selectedPlayer = PlayerClass(tournamentId: "", players: [])
var selectedGame = GameClass(dictionary: ["" : "" as AnyObject])

class GamesTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshController()
        setViewLayout(view: self.view)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //print("viewdidload --- \(String(describing: selectedTour?.tournamentTitle))")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTournamentGames()
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
        fetchTournamentGames()
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
    
    
    func fetchTournamentGames() {
        // Single fetch
        if let selectedId = selectedTour.id {
            Database.database().reference().child("Games").child("Tournaments").child("\(selectedId)").observe(.childAdded, with: {
            
            (snapshot) in
            
            print(snapshot)
            
            
                // Fetch games
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let game = GameClass(dictionary: dictionary)
                    
                    // add game id
                    game.id = snapshot.key
                    game.tournamentId = selectedId
                    print(game.id as Any)
                    
                    // add game to array
                    games.append(game)
                    
                }
                
                self.myArray = games
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.animateTable(tableView: self.myTableView)
                })
                
            }, withCancel: nil)
        }
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
        print(selectGame.name)

    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting..")
            
            // Delete the row from the data source
            if let gamesId = games[indexPath.row].id {
                if let id = checkSelectedIdPositionInGameData(id: gamesId) {
                    games.remove(at: id)
                    } else {
                    print("Failing to delete..")
                }
            }

            
            // This code saves the array whenever an item is deleted.
            myTableView.reloadData()
        }
    }
    

    
}
