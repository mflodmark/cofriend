//
//  TournamentVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class TournamentVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadAnySavedData()
        
        nyTableView.delegate = self
        nyTableView.dataSource = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAnySavedData()
        tableView.reloadData()
    }
    
    // MARK: Declarations

    @IBOutlet var nyTableView: UITableView!
    
    
    // MARK: Functions
    
    func loadAnySavedData() {
        // Load any saved data, otherwise load default.
        addTourData = []
        if let savedData = loadTourData() {
            addTourData += savedData
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
        return addTourData.count
    }
    
    //only ask for the cells for rows that are being displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.TournamentCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TournamentCell
        
        // Fetches the appropriate data for the data source layout.
        let tour = addTourData[indexPath.row]
        cell.name.text = tour.tournamentTitle
        cell.countingPlayer.text = String(tour.players.count)
        
        // Cell status
        //cell.selectionStyle = .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let selectedTournament = addTourData[(indexPath as NSIndexPath).row]
            selectedTour = selectedTournament
            print(selectedTournament.tournamentTitle)
            
    }

    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    

    
    
}
