//
//  InsideTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class InsideTourVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshController()
        setViewLayout(view: self.view)
        

        navigationItem.title = selectedGame.name

        myTableView.delegate = self
        myTableView.dataSource = self
        myUserArray = users
        myUserArray.append(currentUser)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetchScoreId()
        refreshData()
        //animateTable(tableView: myTableView)
        
    }
    
    // MARK: Declarations
    
    @IBOutlet var myTableView: UITableView!

    var gameLeader: String = ""
    var myArray = [ScoreClass]()
    var myUserArray: [UserClass] = []
    var refreshController: UIRefreshControl = UIRefreshControl()
    
    // MARK: Functions
    
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
        fetchScoreId()
        myTableView.reloadData()
        refreshController.endRefreshing()
    }
    
    func checkPoints(a: String, b: String) -> Bool {
        
        //let cell: InsideTourTableViewCell

        
        var height: Bool = false
        if let pA = Int(a), let pB = Int(b) {
            if pA > pB {
                height = true
            }
        }
        return height
        
    }
    
    
    
    func loadWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            //self.nextRound()
        }
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == identifiersSegue.CellToAddTournamentScore.rawValue {
            let tournamentDetailViewController = segue.destination as! ScoreInsideTourVC
            
            // Get the cell that generated this segue.
            if let selectedTournamentCell = sender as? InsideTourTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTournamentCell)!
                let selectedTournament = addTournamentData[(indexPath as NSIndexPath).row]
                tournamentDetailViewController.tournament = selectedTournament
            }
        } else if segue.identifier == identifiersSegue.AddToAddTournamentScore.rawValue {
            print("Adding new ")
        }
    }*/
    
    // MARK: Fetch Data
    
    func fetchScoreId() {
        // Clear arrays
        scores.removeAll()
        teamAArray.removeAll()
        teamBArray.removeAll()
        
        // Fetch game ids
        if let selectedGameId = selectedGame.id {
            Database.database().reference().child("Scores/Games/\(selectedGameId)").observeSingleEvent(of: .value, with: {
                
                (snapshot) in
                
                print(snapshot)
                
                var snapArray: [String] = [String]()
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for each in dictionary {
                        snapArray.append(each.key)
                    }
                }
                
                for each in snapArray {
                    self.fetchUserConnectedToScore(scoreId: each, team: "TeamA")
                    self.fetchUserConnectedToScore(scoreId: each, team: "TeamB")
                    self.fetchScores(scoreId: each)
                }
                
            }, withCancel: nil)
        }
    }
    
    func fetchScores(scoreId: String) {
        
        // Single fetch tournament from user
        Database.database().reference().child("Scores/Games/\(selectedGame.id!)/\(scoreId)").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            print(snapshot)
            
            // Fetch game
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let score = ScoreClass(dictionary: dictionary)
                
                // add id
                score.id = snapshot.key
                
                // add to array
                scores.append(score)
                self.myArray = scores
                
            }
            
            //this will crash because of background thread, so lets use dispatch_async to fix
            DispatchQueue.main.async(execute: {
                self.animateTable(tableView: self.myTableView)
            })
            
        }, withCancel: nil)
    }
    
    
    func fetchUserConnectedToScore(scoreId: String, team: String) {
        // Append players as well
        Database.database().reference().child("Players/Games/\(selectedGame.id!)/\(scoreId)/\(team)").observeSingleEvent(of: .value, with: {
            
            (snapshot: DataSnapshot!) in
            
            print(snapshot)
            
            var snapArray = [String]()
            var snapPlayer = [UserClass]()
            if let snapValue = snapshot.value as? [String: AnyObject] {
                for each in snapValue {
                    if let val = each.value as? Bool {
                        if val == true {
                            snapArray.append(each.key)
                        }
                    }

                }
            }
            
            // fetch user data instead and add to array
            for eachSnap in snapArray {
                for each in self.myUserArray {
                    if each.id == eachSnap {
                        snapPlayer.append(each)
                        //print(players.count as Any)
                    }
                }
            }
            
            if team == "TeamA" {
                teamAArray.append(ScorePlayerClass(gameId: selectedGame.id, scoreId: scoreId, players: snapPlayer))

            } else if team == "TeamB" {
                teamBArray.append(ScorePlayerClass(gameId: selectedGame.id, scoreId: scoreId, players: snapPlayer))
            }
            
            /*
            //this will crash because of background thread, so lets use dispatch_async to fix
            DispatchQueue.main.async(execute: {
                self.animateTable(tableView: self.myTableView)
            })*/

        }, withCancel: nil)
    }
    
    func deleteScoresConnectedToTournament(id: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Scores/Games/\(selectedGame.id!)/\(id)").removeValue()
    }
    
    // MARK: Save data
    
    var teamA: Int = 0
    var teamB: Int = 0
    
    func checkPoints(score: [ScorePlayerClass], p: Int) {
        for each in score {
            if selectedGame.id == each.gameId {
                for eachPlayer in each.players! {
                    for eachP in gamePoints {
                        if eachP.userId == eachPlayer.id {
                            
                        } else {
                            let game = GamePointsClass(id: eachPlayer.id, gameId:  each.gameId, points: p)
                            gamePoints.append(game)
                        }
                    }

                }
            }
        }
    }
    
    func checkLeader() -> String {
        
        var leader: String = ""
        var points: Int = 0
        
        for each in gamePoints {
            if each.points! > points {
                leader = each.userId!
                points = each.points!
            }
            
        }
        
        return leader
    }
    
    
    func saveGameLeader() -> String {
        var leader: String = ""
        
        for each in scores {
            if let pA = Int(each.teamAPoints!), let pB = Int(each.teamBPoints!) {
                if pA > pB {
                    
                    checkPoints(score: teamAArray, p: Int(selectedGame.winPoints!)!)
                    
                    
                    teamB += Int(selectedGame.losePoints!)!
                } else if pA < pB {
                    teamB += Int(selectedGame.winPoints!)!
                    teamA += Int(selectedGame.losePoints!)!

                } else if pA == pB {
                    teamB += Int(selectedGame.drawPoints!)!
                    teamA += Int(selectedGame.drawPoints!)!
                }
            }
        }
        
        leader = checkLeader()
        
        return leader
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
        let cellIdentifier = identifiersCell.InsideTourTableViewCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InsideTourTableViewCell
        
        // Fetches the appropriate data for the data source layout.
        let score = myArray[indexPath.row]
        
        cell.date.text = score.date
        cell.playerScore.text = score.teamAPoints
        cell.friendScore.text = score.teamBPoints
        
        let font = UIFont(name: "Helvetica", size: 30.0)
        let fontSmall = UIFont(name: "Helvetica", size: 20.0)

        
        let height = checkPoints(a: cell.playerScore.text!, b: cell.friendScore.text!)
        if height == true {
            cell.playerScore.font = font
        } else {
            cell.friendScore.font = font
        }
        
        // Draw will have same size
        if cell.playerScore.text! == cell.playerScore.text! {
            cell.playerScore.font = fontSmall
            cell.friendScore.font = fontSmall
        }

        for each in teamAArray {
            if each.scoreId == score.id && each.players?.count == 1 {
                cell.playerOne.text = each.players?[0].name
                cell.playerTwo.isHidden = true
            } else if each.scoreId == score.id && each.players?.count == 2 {
                cell.playerOne.text = each.players?[0].name
                cell.playerTwo.text = each.players?[1].name
            }
        }
        
        for each in teamBArray {
            if each.scoreId == score.id && each.players?.count  == 1 {
                cell.friendOne.text = each.players?[0].name
                cell.friendTwo.isHidden = true
            } else if each.scoreId == score.id && each.players?.count  == 2 {
                cell.friendOne.text = each.players?[0].name
                cell.friendTwo.text = each.players?[1].name
            }
        }
        
        // Fix point height with delay
        //loadWithDelay(seconds: 1)

        return cell
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting..")
            
            // Delete the row from the data source
            if let selectedId = myArray[indexPath.row].id {
                if let id = checkSelectedIdPositionInScoreData(id: selectedId) {
                    scores.remove(at: id)
                    deleteScoresConnectedToTournament(id: selectedId)
                } else {
                    print("Failing to delete..")
                }
                
            }

            // This code saves the array whenever an item is deleted.
            myTableView.reloadData()
        }
    }*/
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
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
        let selectedScoreInArray = myArray[(indexPath as NSIndexPath).row]
        selectedScore = selectedScoreInArray

        // Check if player created the tournament or not
        if let id = selectedScore.createdByUserId {
            if userCreatedScore(id: id) == true {
                selectedScoreCell = true
                
                // Perform segue to edit
                performSegue(withIdentifier: identifiersSegue.AddScore.rawValue, sender: "selectedCell")
            }
        } else {
            // Alert that edit is not possible because user did not create tournament
            showAlert(title: "Edit mode not possible", message: "You are not the creator of this score", dismissButton: "Cancel", okButton: "Ok", sender: "Edit", indexPath: indexPath)
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
            if let selectedId = myArray[indexPath.row].id {
                if let id = checkSelectedIdPositionInScoreData(id: selectedId) {
                    scores.remove(at: id)
                    deleteScoresConnectedToTournament(id: selectedId)
                } else {
                    print("Failing to delete..")
                }
                
            }
            
            // This code saves the array whenever an item is deleted.
            refreshData()
        }
    }
    
    func userCreatedScore(id: String) -> Bool {
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
        if segue.identifier == identifiersSegue.AddScore.rawValue && sender as? String != "selectedCell"{
            selectedScoreCell = false
        }
    }
    
    
}
