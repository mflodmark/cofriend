//
//  AddTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

var playerArray = [UserClass]()

class AddTourVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        setUpRefreshController()
        setViewLayout(view: self.view)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        createTitles()
        
        setRound(button: newPlayer)
        myArray.removeAll()
        myArray = users
        myArray.append(currentUser)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerArray.removeAll()
        getAlreadySelectedPlayers()
        animateTable(tableView: self.myTableView)
        //fetchUser()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
        
    }
    


    // MARK: Declaration
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addedPlayers: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var newPlayer: UIButton!
    
    var win = 0
    var draw = 0
    var lose = 0
    var refreshController: UIRefreshControl = UIRefreshControl()
    var myArray: [UserClass] = [UserClass]()

    
    // MARK: Actions
    
    @IBAction func resignButton(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        saveNewTournament()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func newPlayerAction(_ sender: UIButton) {
        bounceButton(theButton: sender)
    }
    
    // MARK: Fetch Users
        /*
    func fetchUser() {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Users").queryOrderedByKey().observe(.childAdded, with: {
            
            (snapshot) in
            
            // Fetch user
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = UserClass(dictionary: dictionary)
                // add user id to UserClass
                user.id = snapshot.key
                print("userid -----> " + user.id!)
                users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.animateTable(tableView: self.myTableView)
                })
                
            }
            
        }, withCancel: nil)
    }
    */
    
    // MARK: Functions
    
    func createTitles() {
        addedPlayers.text = "Added players: \(playerArray.count)"
        if selectedTourCell == true {
            if let name = selectedTour.name {
                textField.text = name
            }
        } else if selectedTourCell == false {
            textField.text = ""
        }
    }
    
    func updatePlayerTitles() {
        addedPlayers.text = "Added players: \(playerArray.count)"
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
        myTableView.reloadData()
        refreshController.endRefreshing()
    }

    
    // Done button added to textfield
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let toolBar = UIToolbar()

    
    func addDoneButtonToTextField(field: UITextField, button: UIBarButtonItem) {
        toolBar.setItems([flexibleSpace, button], animated: false)
        field.inputAccessoryView = toolBar
        toolBar.sizeToFit()
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    

    func checkUidInPlayerArray() -> Bool {
        var checked: Bool = false
        let uid = Auth.auth().currentUser?.uid
        
        for each in playerArray {
            if uid! == each.id {
                checked = true
            }
        }
        
        return checked
    }

    
    func saveNewTournament() {
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        if let text = textField.text {
            if playerArray.count > 0 {
                
                let post: [String : AnyObject] = ["name" : text as AnyObject, "createdByUserId": Auth.auth().currentUser?.uid as AnyObject]
                
                //var postPlayers: [String:AnyObject] = [:]
                
                // Check i user have choosed themselves
                if checkUidInPlayerArray() == false {
                    showAlert(title: "Missing you as a player", message: "Please add yourself as a player", dismissButton: "Cancel", okButton: "Ok")
                } else {
                    
                    // Save to folder tournament
                    let newRef = databaseRef.child("Tournaments").childByAutoId()
                    let newId = newRef.key
                    
                    // Check if in save or edit mode
                    if selectedTourCell == false {
                        // Save tournament
                        newRef.setValue(post)
                        
                    } else {
                        // Edit tournament
                        if let selId = selectedTour.id {
                            databaseRef.child("Tournaments/\(selId)").setValue(post)
                            // Remove all players
                            databaseRef.child("Players/Tournaments/\(selId)").removeValue()
                        }
                    }
                    
                    addToPlayersArray(id: newId, playerArray: playerArray)
                    
                    // Tournaments -> Id -> Players => add players
                    for each in playerArray {
                        if let id = each.id {
                            // Check if in save or edit mode
                            if selectedTourCell == false {
                                // Save
                                databaseRef.child("Players/Tournaments/\(newId)/\(id)").setValue(true)
                                databaseRef.child("Users/\(id)/Tournaments").updateChildValues([newId:true])
                            } else {
                                // Edit
                                if let selId = selectedTour.id {
                                    databaseRef.child("Players/Tournaments/\(selId)/\(id)").setValue(true)
                                    databaseRef.child("Users/\(id)/Tournaments").updateChildValues([selId:true])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addToPlayersArray(id: String, playerArray: [UserClass]) {
        players.append(PlayerClass(tournamentId: id, players: playerArray))
    }
    
    func showAlert(title: String, message: String, dismissButton: String, okButton: String) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            //self.alertOkFunctions()
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            //self.alertDismissFunctions()
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }

    func getAlreadySelectedPlayers() {
        for each in players {
            // If selected tour
            if each.tournamentId == selectedTour.id {
                playerArray = each.players!
            }
        }
    }
    
    // MARK: - Table view data source
    
    //tells the table view how many sections to display.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counter = 0
        if tableView == myTableView {
            counter = myArray.count
        }
        return counter
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Identifiers
        let cellIdentifier = identifiersCell.AddTourCell.rawValue
        let cellPlayerIdentifier = identifiersCell.AddPlayerCell.rawValue
        
        if tableView == myTableView {
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddTourCell
            
            // Fetches the appropriate data for the data source layout.
            let user = myArray[indexPath.row]
            
            cell.myLabel.text = user.name
            
            for each in players {
                // If selected tour
                if each.tournamentId == selectedTour.id {
                    for eachP in each.players! {
                        if eachP.id == user.id {
                            cell.myLabel.backgroundColor = UIColor.darkGray
                        }
                    }
                }
            }
            
            // Cell status
            tableView.allowsMultipleSelection = true
            return cell

        } else {
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cell = tableView.dequeueReusableCell(withIdentifier: cellPlayerIdentifier, for: indexPath) as! AddTourCell
            
            // Fetches the appropriate data for the data source layout.
            let user = playerArray[indexPath.row]
            cell.myLabel.text = user.name
            
            // Cell status
            tableView.allowsSelection = false

            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselect(indexPath: indexPath)
        
    }
    
    func didSelect(indexPath: IndexPath) {
        let user = myArray[indexPath.row]
        playerArray.append(user)
        addedPlayers.text = "Added players: \(playerArray.count)"
    }
    
    func didDeselect(indexPath: IndexPath) {
        let user = myArray[indexPath.row]
        
        if let id = user.id {
            if let check = checkSelectedIdPositionInPlayer(id: id) {
                playerArray.remove(at: check)
                updatePlayerTitles()
            }
        }
    }
    
    func checkPlayerArray(indexPath: IndexPath) -> Bool {
        var check: Bool = false
        for each in playerArray {
            if each.id == myArray[indexPath.row].id {
                check = true
                
            }
        }
        return check
    }
}
