//
//  ScoreInsideTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

// Global declarations
var teamOneArray = [StoredUserData]()
var teamTwoArray = [StoredUserData]()
var dateString: String? = "No date available"

class ScoreInsideTourVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTodaysDate()
        setViewLayout(view: self.view)
        setRoundButtons()
        
        collectionArray.append("Markus")
        
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // Clear array before adding new users to score
        teamOneArray.removeAll()
        teamTwoArray.removeAll()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Viewwillappear --- \(String(describing: dateString))")
        if dateString == "No date available" {
            addTodaysDate()
        } else {
            if let text = dateString {
                dateButton.setTitle(text, for: .normal)
            }
        }
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
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var collTableView: UITableView!
    
    var pointA = Int()
    var pointB = Int()
    var myArray = selectedTour?.players
    var collectionArray = [String]()
    //var buttonPressed: UIButton = UIButton()
    //let datePickerClass = DatePickerClass()
    //let scoreInsideCell = ScoreInsideCell()
    var image: UIImage = UIImage()
    
    
    
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
            bounceLabelStepper(label: pointsA, sender: sender)
        } else if sender == stepperB {
            bounceLabelStepper(label: pointsB, sender: sender)
        }
    }
    
    
    
    // MARK: Functions
    
    
    func setRoundButtons() {
        setRound(button: dateButton)
        setRound(button: addPointsButton)
    }
    
    func bounceLabelStepper(label: UILabel, sender: UIStepper) {
        // Make the label bounce
        label.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            
            label.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
        label.text = "\(Int(sender.value))"

    }
    
    func bounceButton(theButton: UIButton) {
        let bounds = theButton.bounds
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }) { (success:Bool) in
            if success {
                
                UIView.animate(withDuration: 0.5, animations: {
                    theButton.bounds = bounds
                })
                
            }
        }
    }

    
    func addTodaysDate() {
        // Add todays date to dateButton
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let result = formatter.string(from: date)
        
        dateButton.setTitle(result, for: .normal)
    }
    
    func getDateFromDatePicker() {
        dateButton.setTitle(dateString, for: .normal)
    }
    
    func prepareSavingData() {
        
        print("teamOneArray count     \(teamOneArray.count)")
        print("teamTwoArray count     \(teamTwoArray.count)")
    
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
        var integer = 0
        
        if tableView == myTableView {
            integer = (myArray?.count)!
        } else if tableView == collTableView {
            integer = 1
        }
        
        return integer
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var viewCell = UITableViewCell()
        
        if tableView == myTableView {
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = identifiersCell.ScoreInsideCell.rawValue
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ScoreInsideCell
            
            // Fetches the appropriate data for the data source layout.
            if let score = myArray?[indexPath.row] {
                cell.label.text = score.username
                cell.user = score
            }
            
            
            // Cell status
            tableView.allowsSelection = false
            
            viewCell = cell
            
        } else if tableView == collTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifiersCell.TableCollCell.rawValue, for: indexPath) as! TableViewCollCell
            
            
            viewCell = cell
        }

        return viewCell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == collTableView {
            guard let tableViewCell = cell as? TableViewCollCell else { return }
            
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        }
    }
    
    var storedOffsets = [Int: CGFloat]()
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == collTableView {
            guard let tableViewCell = cell as? TableViewCollCell else { return }
        
            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        }
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
        cell.setLabel.text = "Set: \(indexPath.row)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }

    

    
}
