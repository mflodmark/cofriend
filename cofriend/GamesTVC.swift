//
//  GamesTVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

var selectedTour = StoredTourData(tournamentTitle: "", players: [], pointsWin: 0, pointsDraw: 0, pointsLose: 0, id: 0)

var selectedGame = StoredGameTitleData(tournamentTitle: "", scoreTitle: "", id: 0)

class GamesTVC: UITableViewController {
    
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
    
    @IBOutlet var myTableView: UITableView!
    
    var myArray = addGameTitle
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
        myTableView.reloadData()
        refreshController.endRefreshing()
    }
    
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
    
    func loadAnySavedData() {
        // Load any saved data, otherwise load default.
        addGameTitle = []
        if let savedData = loadGameTitleData() {
            addGameTitle += savedData
        }
        
    }
    
    func loadMyArray() {
        myArray = []
        for each in addGameTitle {
            if each.tournamentTitle == selectedTour?.tournamentTitle {
                myArray.append(each)
            }
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
        cell.myLabel.text = game.scoreTitle
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGame = myArray[(indexPath as NSIndexPath).row]
        selectedGame = selectGame
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    

    
}
