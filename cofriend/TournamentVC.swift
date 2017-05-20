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
    
    // MARK: Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //loadAnySavedData()
        setUpRefreshController()
        setViewLayout(view: self.view)
        
        nyTableView.delegate = self
        nyTableView.dataSource = self
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loadAnySavedData()
        //nyTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func loadAnySavedData() {
        // Load any saved data, otherwise load default.
        addTourData = []
        if let savedData = loadTourData() {
            addTourData += savedData
        }
        
    }
    
    func animateTable(tableView: UITableView) {
        loadAnySavedData()

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


    
    // MARK: - Table view data source
    
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
