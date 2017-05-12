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
        
        loadAnySavedData()
        loadMyArray()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAnySavedData()
        loadMyArray()
        myTableView.reloadData()
    }
    
    
    
    @IBOutlet var myTableView: UITableView!
    
    var myArray = addGameTitle
    var gameTitle = String()
    
    
    // MARK: Functions
    
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
    
    /*To display dynamic data, a table view needs two important helpers: a data source and a delegate. A table view data source, as implied by its name, supplies the table view with the data it needs to display. A table view delegate helps the table view manage cell selection, row heights, and other aspects related to displaying the data.*/
    
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
        let cellIdentifier = identifiersCell.GamesCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddGameCell
        
        // Fetches the appropriate data for the data source layout.
        let game = myArray[indexPath.row]
        cell.myLabel.text = game.scoreTitle
        
        // Cell status
        //cell.selectionStyle = .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
}
