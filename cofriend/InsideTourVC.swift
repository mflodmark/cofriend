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
        
        //loadAnySavedData()
        //loadMyArray()
        setUpRefreshController()
        setViewLayout(view: self.view)
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //loadAnySavedData()
        //loadMyArray()
        //myTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable(tableView: myTableView)
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
            if each.tournamentTitle == selectedTour?.tournamentTitle && each.gameTitle == selectedGame?.scoreTitle {
                myArray.append(each)
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    }
    
    
    // MARK: - Table view data source
        
    //tells the table view how many sections to display.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addTournamentData.count
    }
    
    //only ask for the cells for rows that are being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.InsideTourTableViewCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InsideTourTableViewCell
        
        // Fetches the appropriate data for the data source layout.
        let tour = addTournamentData[(indexPath as NSIndexPath).row]
        
        cell.date.text = tour.date
        cell.playerScore.text = String(tour.teamOneScore)
        cell.friendScore.text = String(tour.teamTwoScore)
        cell.playerOne.text = tour.teamOnePlayers[0].username
        cell.friendOne.text = tour.teamTwoPlayers[0].username
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            addTournamentData.remove(at: (indexPath as NSIndexPath).row)
            
            // This code saves the meals array whenever a meal is deleted.
            saveTournamentData()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    @IBAction func unwindToMealList(_ sender: UIStoryboardSegue) {
        
        /*Optional type cast operator (as?), downcast the source view controller of the segue to type MealViewController. You need to downcast because sender.sourceViewController is of type UIViewController, but you need to work with MealViewController.
         The operator returns an optional value, which will be nil if the downcast wasn’t possible. If the downcast succeeds, the code assigns that view controller to the local constant sourceViewController, and checks to see if the meal property on sourceViewController is nil. If the meal property is non-nil, the code assigns the value of that property to the local constant meal and executes the if statement.
         If either the downcast fails or the meal property on sourceViewController is nil, the condition evaluates to false and the if statement doesn’t get executed.*/
        
        if let sourceViewController = sender.source as? ScoreInsideTourVC, let tour = sourceViewController.tournament {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                addTournamentData[(selectedIndexPath as NSIndexPath).row] = tour
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new meal.
                let newIndexPath = IndexPath(row: addTournamentData.count, section: 0)
                addTournamentData.append(tour)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            // Save the meals.
            saveTournamentData()
        }
    }
    
    
}
