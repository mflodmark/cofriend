//
//  InsideTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class InsideTourVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshController()
        setViewLayout(view: self.view)
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable(tableView: myTableView)
        
        // Check id
        for each in myArray {
            print("Id counter:   \(each.id)")
        }
    }
    
    // MARK: Declarations
    
    @IBOutlet var myTableView: UITableView!

    var myArray = addTournamentData
    var refreshController: UIRefreshControl = UIRefreshControl()
    
    // MARK: Functions
    
    func animateTable(tableView: UITableView) {
        loadAnySavedData()
        loadMyArray()
        
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
        loadAnySavedData()
        loadMyArray()
        myTableView.reloadData()
        refreshController.endRefreshing()
    }
    
    func loadAnySavedData() {
        addTournamentData = []
        if let savedData = loadTournamentData() {
            addTournamentData += savedData
        }
    }
    
    func loadMyArray() {
        myArray = []
        for each in addTournamentData {
            if each.tournamentTitle == selectedTour.name && each.gameTitle == selectedGame.name {
                myArray.append(each)
            }
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
        let tour = myArray[indexPath.row]
        
        cell.date.text = tour.date
        cell.playerScore.text = String(tour.teamOneScore)
        cell.friendScore.text = String(tour.teamTwoScore)
        
        if tour.teamOnePlayers.count == 1 {
            cell.playerOne.text = tour.teamOnePlayers[0].username
            cell.playerTwo.isHidden = true
        } else if tour.teamOnePlayers.count == 2 {
            cell.playerOne.text = tour.teamOnePlayers[0].username
            cell.playerTwo.text = tour.teamOnePlayers[1].username
        }
        
        if tour.teamTwoPlayers.count == 1 {
            cell.friendOne.text = tour.teamTwoPlayers[0].username
            cell.friendTwo.isHidden = true
        } else if tour.teamTwoPlayers.count == 2 {
            cell.friendOne.text = tour.teamTwoPlayers[0].username
            cell.friendTwo.text = tour.teamTwoPlayers[1].username
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting..")
            
            // Delete the row from the data source
            if let id = checkSelectedIdPositionInScoreData(id: myArray[indexPath.row].id) {
                addTournamentData.remove(at: id)
            } else {
                print("Failing to delete..")
            }
            
            // This code saves the array whenever an item is deleted.
            saveTournamentData()
            loadAnySavedData()
            loadMyArray()
            myTableView.reloadData()
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
}
