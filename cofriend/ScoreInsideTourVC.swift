//
//  ScoreInsideTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class ScoreInsideTourVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTodaysDate()
        
        //collectionArray[0] = "Markus"
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myCollactionView.delegate = self
        myCollactionView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let text = datePickerClass.returnDate()
        dateButton.setTitle(text, for: .normal)
    }
    
    // MARK: Declarations
    let teamOneDefault = StoredUserData(username: "No Data", image: #imageLiteral(resourceName: "DefaultImage"), id: 0)
    let teamTwoDefault = StoredUserData(username: "No Data", image: #imageLiteral(resourceName: "DefaultImage"), id: 0)

    var tournament = StoredTournamentData(tournamentTitle: "No Data", gameTitle: "", teamOnePlayers: [], teamTwoPlayers: [], teamOneScore: 0, teamTwoScore: 0, image: #imageLiteral(resourceName: "DefaultImage"), date: "No Data", id: 0)

    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var pointsA: UILabel!
    @IBOutlet weak var pointsB: UILabel!
    @IBOutlet weak var addPointsButton: UIButton!
    @IBOutlet weak var stepperA: UIStepper!
    @IBOutlet weak var stepperB: UIStepper!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myCollactionView: UICollectionView!

    var teamOneArray = [StoredUserData]()
    var teamTwoArray = [StoredUserData]()
    var pointA = Int()
    var pointB = Int()
    var myArray = selectedTour?.players
    var collectionArray = [String]()
    var buttonPressed: UIButton = UIButton()
    let datePickerClass = DatePickerClass()
    let scoreInsideCell = ScoreInsideCell()
    
    
    // MARK: Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        prepareSavingData()
        saveTournamentData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateActionButton(_ sender: UIButton) {


    }
    
    @IBAction func addPointsActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender == stepperA {
            pointA = Int(sender.value)
            pointsA.text = "\(pointA)"
        } else if sender == stepperB {
            pointB = Int(sender.value)
            pointsB.text = "\(pointB)"
        }
    }
    
    @IBAction func teamAActionButton(_ sender: UIButton) {
        buttonPressed = sender
    }
    
    
    @IBAction func teamBActionButton(_ sender: UIButton) {
        buttonPressed = sender

    }
    
    
    // MARK: Functions

    
    func addTodaysDate() {
        // Add todays date to dateButton
    }
    
    func prepareSavingData() {
        if let tournament = selectedTour?.tournamentTitle, let game = selectedGame?.scoreTitle, let date = dateButton.title(for: .normal), let pointsACast = Int(pointsA.text!), let pointsBCast = Int(pointsB.text!) {
            let game = StoredTournamentData(tournamentTitle: tournament, gameTitle: game, teamOnePlayers: teamOneArray, teamTwoPlayers: teamTwoArray, teamOneScore: pointsACast, teamTwoScore: pointsBCast, image: #imageLiteral(resourceName: "DefaultImage"), date: date, id: idForTournamentData)
            addTournamentData.append(game!)
            
            idForTournamentData += 1
            // Save id
            UserDefaults.standard.set(String(idForTournamentData), forKey: forKey.TournamentDataId.rawValue)
        }
    }
    
    // MARK: - Table view data source
        
    //tells the table view how many sections to display.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (myArray?.count)!
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.ScoreInsideCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ScoreInsideCell
        
        // Fetches the appropriate data for the data source layout.
        let score = myArray?[indexPath.row].username
        cell.label.text = score
        
        // Cell status
        tableView.allowsMultipleSelection = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = myArray?[(indexPath as NSIndexPath).row]

    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.ScoreCollCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ScoreCollCell
        
        // Fetches the appropriate data for the data source layout.
        let scoreLabel = collectionArray
        cell.myLabel.text = scoreLabel[indexPath.row]
        
        
        return cell
    }
    
}
