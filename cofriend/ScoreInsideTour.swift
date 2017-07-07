//
//  ScoreInsideTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

// Global declarations
var teamOneArray = [UserClass]()
var teamTwoArray = [UserClass]()
var dateString: String? = "No date available"

class ScoreInsideTourVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDate()
        setViewLayout(view: self.view)
        
        //collectionArray = ["1-0", "2-1"]
        
        
        myTableView.delegate = self
        myTableView.dataSource = self
        //myCollectionView.delegate = self
        
        // Clear array before adding new users to score
        teamOneArray.removeAll()
        teamTwoArray.removeAll()
        
        hidePenaltiesQuestion()
        setPreSeclectedScore()
        hideButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Viewwillappear --- \(String(describing: dateString))")
        if dateString == "No date available" {
            addDate()
        } else {
            if let text = dateString {
                dateButton.setTitle(text, for: .normal)
            }
        }
    }
    
    
    // MARK: Declarations
    //let teamOneDefault = StoredUserData(username: "No Data", image: #imageLiteral(resourceName: "DefaultImage"), id: 0)
    //let teamTwoDefault = StoredUserData(username: "No Data", image: #imageLiteral(resourceName: "DefaultImage"), id: 0)

    //var tournament = StoredTournamentData(tournamentTitle: "No Data", gameTitle: "", teamOnePlayers: [], teamTwoPlayers: [], teamOneScore: 0, teamTwoScore: 0, image: #imageLiteral(resourceName: "DefaultImage"), date: "No Data", id: 0)

    
    //@IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var pointsA: UILabel!
    @IBOutlet weak var pointsB: UILabel!
    @IBOutlet weak var addGoalScorerButton: UIButton!
    @IBOutlet weak var stepperA: UIStepper!
    @IBOutlet weak var stepperB: UIStepper!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    
    @IBOutlet weak var overtimeStack: UIStackView!
    
    @IBOutlet weak var penaltyStack: UIStackView!
    @IBOutlet weak var penaltiesQuestion: UIStackView!
    @IBOutlet weak var penaltiesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var overtimeSegmentedControl: UISegmentedControl!
    var pointA = Int()
    var pointB = Int()
    var myArray = selectedPlayer.players
    //var collectionArray = [String]()
    //var buttonPressed: UIButton = UIButton()
    //let datePickerClass = DatePickerClass()
    //let scoreInsideCell = ScoreInsideCell()
    var image: UIImage = UIImage()
    var overtime: Bool = false
    var penalties: Bool = false
    var penaltyWinner: String = ""
    
    @IBOutlet weak var penaltyB: UIButton!
    @IBOutlet weak var penaltyA: UIButton!
    
    // MARK: Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        //prepareSavingData()
        //saveTournamentData()
        saveNewScore()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateActionButton(_ sender: UIButton) {

    }
    
    @IBAction func addGoalscorerAction(_ sender: UIButton) {
        if teamOneArray.count < 1 || teamTwoArray.count < 1 {
            // Alert if no player is chosen
            //showAlert(title: "Add goalscorers", message: "Please choose players first", dismissButton: "Cancel", okButton: "Ok")
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender == stepperA {
            bounceLabelStepper(label: pointsA, sender: sender)
        } else if sender == stepperB {
            bounceLabelStepper(label: pointsB, sender: sender)
        }
        setPreSeclectedScore()
    }
    
    
    @IBAction func segmentedControlToggle(_ sender: UISegmentedControl) {
        if sender == overtimeSegmentedControl {
            if sender.selectedSegmentIndex == 0 {
                overtime = true
            } else {
                overtime = false
            }
            
        } else if sender == penaltiesSegmentedControl {
            if sender.selectedSegmentIndex == 0 {
                penalties = true
                showPenaltiesQuestion()
            } else {
                penalties = false
                hidePenaltiesQuestion()
            }
        }
    }
    
    @IBAction func penaltyWinner(_ sender: UIButton) {
        if sender == penaltyA {
            penaltyWinner = "A"
            sender.setTitleShadowColor(.darkGray, for: .normal)
        } else if sender == penaltyB {
            penaltyWinner = "B"
            sender.setTitleShadowColor(.darkGray, for: .normal)
        }
    }
    
    
    
    // MARK: Functions
    
    func hideButtons() {
        addGoalScorerButton.isHidden = true
        overtimeStack.isHidden = true
        penaltyStack.isHidden = true
        
        if selectedGame.name == "FIFA" || selectedGame.name == "NHL" {
            addGoalScorerButton.isHidden = false
            overtimeStack.isHidden = false
            penaltyStack.isHidden = false
        }
    }
    
    func setPreSeclectedScore() {
        preSelectedScore.teamAPoints = pointsA.text!
        preSelectedScore.teamBPoints = pointsB.text!
    }
    
    func hidePenaltiesQuestion() {
        penaltiesQuestion.isHidden = true
    }
    
    func showPenaltiesQuestion() {
        penaltiesQuestion.isHidden = false
    }
    
    func setValues() {
        if selectedScoreCell == false {
            setValuesForSelectedGame()
            pointA = 0
            pointB = 0
        } else if selectedScoreCell == true {
            pointA = Int(selectedScore.teamAPoints!)!
            pointB = Int(selectedScore.teamBPoints!)!
        }
    }
    
    func setValuesForSelectedGame() {
        if selectedGame.name == defaultGames.fifa.rawValue {
            
        }
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

    
    func addDate() {
        // Add todays date to dateButton
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        if selectedScoreCell == false {
            dateButton.setTitle(result, for: .normal)
        } else if selectedScoreCell == true {
            dateButton.setTitle(selectedScore.date!, for: .normal)
        }

    }
    
    func getDateFromDatePicker() {
        dateButton.setTitle(dateString, for: .normal)
    }
    /*
    func prepareSavingData() {
        
        print("teamOneArray count     \(teamOneArray.count)")
        print("teamTwoArray count     \(teamTwoArray.count)")
    
        if let tournament = selectedTour.name, let game = selectedGame.name, let date = dateButton.title(for: .normal), let pointsACast = Int(pointsA.text!), let pointsBCast = Int(pointsB.text!) {
            
            //let game = StoredTournamentData(tournamentTitle: tournament, gameTitle: game, teamOnePlayers: teamOneArray, teamTwoPlayers: teamTwoArray, teamOneScore: pointsACast, teamTwoScore: pointsBCast, image: #imageLiteral(resourceName: "DefaultImage"), date: date, id: idForTournamentData)
            
            //addTournamentData.append(game!)
            
            idForTournamentData += 1
            // Save id
            UserDefaults.standard.set(String(idForTournamentData), forKey: forKey.TournamentDataId.rawValue)
        }
    }*/

    

    
    func saveNewScore() {
        
        if let game = selectedGame.name, let date = dateButton.title(for: .normal), let pointsA = pointsA.text, let pointsB = pointsB.text {
            
            var databaseRef: DatabaseReference!
            databaseRef = Database.database().reference()
            
            let post: [String : AnyObject] = ["name" : game as AnyObject, "createdByUserId": Auth.auth().currentUser?.uid as AnyObject, "date" : date as AnyObject, "teamAPoints" : pointsA as AnyObject, "teamBPoints" : pointsB as AnyObject, "overtime": overtime as AnyObject, "penalties": penalties as AnyObject, "penaltyWinner": penaltyWinner as AnyObject]
            
            
            // Games -> Tournaments -> Id => post
            if let selectedGameId = selectedGame.id {
                
                // Error handling if not adding players
                if teamOneArray.count == 0 || teamTwoArray.count == 0 {
                    showAlert(title: "Player missing", message: "Add players", dismissButton: "Cancel", okButton: "Ok")
                
                } else {
                    
                    // if players are added
                    let newRef = databaseRef.child("Scores").child("Games").child("\(selectedGameId)").childByAutoId()
                    let newId = newRef.key
                    newRef.setValue(post)
                    
                    // Update selected goalscorers
                    //selectedScorePlayer.gameId = selectedGame.id
                    //selectedScorePlayer.scoreId = newId
                    
                    var count = 0
                    for each in teamOneArray {
                        
                        // Save A array
                        if let eachId = each.id {
                            count += 1
                            databaseRef.child("Players/Games/\(selectedGameId)/\(newId)/TeamA/\(eachId)").setValue(true)
                            if count == 1 {
                                databaseRef.child("Players/Games/\(selectedGameId)/\(newId)/TeamAGoals/\(eachId)").setValue(String(teamAOneGoals))
                            } else if count == 2 {
                                databaseRef.child("Players/Games/\(selectedGameId)/\(newId)/TeamAGoals/\(eachId)").setValue(String(teamATwoGoals))
                            }
                        }
                    }
                    
                    count = 0
                    for each in teamTwoArray {
                        // Save B array
                        if let eachId = each.id {
                            count += 1
                            databaseRef.child("Players/Games/\(selectedGameId)/\(newId)/TeamB/\(eachId)").setValue(true)
                            if count == 1 {
                                databaseRef.child("Players/Games/\(selectedGameId)/\(newId)/TeamBGoals/\(eachId)").setValue(String(teamBOneGoals))
                            } else if count == 2 {
                                databaseRef.child("Players/Games/\(selectedGameId)/\(newId)/TeamBGoals/\(eachId)").setValue(String(teamBTwoGoals))
                            }
                        }

                    }
                
                    setWinForUsers()
                }
            }
        }
    }
    
    
    
    func getUsersPoints(userId: String, varP: String) -> Int {
        
        var p: Int = 0
        
        for each in users {
            if each.id == userId && varP == "Win" {
                // Default value
                each.win = "0"
                p = Int(each.win!)!
            } else if each.id == userId && varP == "Draw" {
                // Default value
                each.draw = "0"
                p = Int(each.draw!)!
            } else if each.id == userId && varP == "Lose" {
                // Default value
                each.lose = "0"
                p = Int(each.lose!)!
            }
        }
        
        return p
    }
    
    func setUsersPoints(userArray: [UserClass], varP: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        for each in userArray {
            if let eachId = each.id {
                var p = getUsersPoints(userId: eachId, varP: varP)
                p += 1
                databaseRef.child("Users/\(eachId)/\(varP)").setValue(String(p))
            }
        }
    }
    
    
    func setWinForUsers() {

        if let pA = Int(pointsA.text!), let pB = Int(pointsB.text!) {
            if pA > pB {
                setUsersPoints(userArray: teamOneArray, varP: "win")
                setUsersPoints(userArray: teamTwoArray, varP: "lose")

            } else if pA < pB {
                setUsersPoints(userArray: teamTwoArray, varP: "win")
                setUsersPoints(userArray: teamOneArray, varP: "lose")

            } else if pA == pB {
                setUsersPoints(userArray: teamTwoArray, varP: "draw")
                setUsersPoints(userArray: teamOneArray, varP: "draw")
            }
        }

    }
    
    // MARK: Alert
    
    func alertOkFunctions() {
        
    }
    
    func alertDismissFunctions() {
        
    }
    
    func showAlert(title: String, message: String, dismissButton: String, okButton: String) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.alertOkFunctions()
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel logic here")
            self.alertDismissFunctions()
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
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
                cell.label.text = score.name
                cell.user = score
            }
            
            
            // Cell status
            tableView.allowsSelection = false
            
            viewCell = cell
            
        }

        return viewCell
    }
    
    
    
    // MARK: Collection view
    /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.ScoreCollCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ScoreCollCell
        
        // Fetches the appropriate data for the data source layout.
        let scoreLabel = collectionArray
        cell.backgroundColor = UIColor.yellow
        cell.myLabel.text = scoreLabel[indexPath.row]
        cell.setLabel.text = "Set: \(indexPath.row)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }*/

    

    
}
