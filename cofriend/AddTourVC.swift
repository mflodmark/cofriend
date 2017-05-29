//
//  AddTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class AddTourVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        createTitles()
        stepperValues()
        //addDoneButtonToTextField(field: textField, button: doneButton)
        //loadAnySavedData()
        setUpRefreshController()
        //animateConstraints()
        setViewLayout(view: self.view)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        setRound(button: newPlayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //animateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable(tableView: myTableView)
    }

    // MARK: Declaration
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pointsWin: UILabel!
    @IBOutlet weak var pointsDraw: UILabel!
    @IBOutlet weak var pointsLose: UILabel!
    @IBOutlet weak var winStepper: UIStepper!
    @IBOutlet weak var drawStepper: UIStepper!
    @IBOutlet weak var loseStepper: UIStepper!
    @IBOutlet weak var addedPlayers: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var newPlayer: UIButton!
    
    var win = 0
    var draw = 0
    var lose = 0
    var playerArray = [StoredUserData]()
    var refreshController: UIRefreshControl = UIRefreshControl()


    
    // MARK: Actions
    
    @IBAction func resignButton(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        prepareSavingData()
        saveTourData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender == winStepper {
            win = Int(sender.value)
        } else if sender == drawStepper {
            draw = Int(sender.value)
        } else if sender == loseStepper {
            lose = Int(sender.value)
        }
        createTitles()
    }
    
    
    @IBAction func newPlayerAction(_ sender: UIButton) {
        bounceButton(theButton: sender)
    }
    
    
    // MARK: Functions
    
    /*
    func animateConstraints() {
        button1Constraint.constant -= view.bounds.width
        button2Constraint.constant -= view.bounds.width
    }
    
    var animationPerformedOnce = false
    
    func animateView() {
        
        while animationPerformedOnce == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.button1Constraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                self.button2Constraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            animationPerformedOnce = true
        }
    }*/
    
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
    
    func loadAnySavedData() {
        // Load any saved data
        addUserData = []
        if let savedData = loadUserData() {
            addUserData += savedData
        }
    }
    
    

    func stepperValues() {
        
        winStepper.wraps = true
        winStepper.autorepeat = true
        winStepper.maximumValue = 100
        
        drawStepper.wraps = true
        drawStepper.autorepeat = true
        drawStepper.maximumValue = 100
        
        loseStepper.wraps = true
        loseStepper.autorepeat = true
        loseStepper.maximumValue = 100
    }
    
    func createTitles() {
        pointsWin.text = "Points for win: \(win)"
        pointsDraw.text = "Points for draw: \(draw)"
        pointsLose.text = "Points for lose: \(lose)"
        addedPlayers.text = "Added players: \(playerArray.count)"
    }
    
    func prepareSavingData() {
        if let text = textField.text {
            if playerArray.count > 0 {
                let tour = StoredTourData(tournamentTitle: text, players: playerArray, pointsWin: win, pointsDraw: draw, pointsLose: lose, id: idForTourData)
                
                addTourData.append(tour!)
                
                idForTourData += 1
                // Save id
                UserDefaults.standard.set(String(idForTourData), forKey: forKey.TourDataId.rawValue)
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
        return addUserData.count
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.AddTourCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddTourCell
        
        // Fetches the appropriate data for the data source layout.
        let user = addUserData[indexPath.row]
        cell.myLabel.text = user.username
        
        // Cell status
        tableView.allowsMultipleSelection = true
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = addUserData[indexPath.row]
        //let cell: AddTourCell = tableView.cellForRow(at: indexPath) as! AddTourCell
        
        playerArray.append(user)


        createTitles()
        print("Selected cell")
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let user = addUserData[indexPath.row]
        if let check = checkSelectedIdPositionInUserData(id: user.id) {
            playerArray.remove(at: check)
            createTitles()
        }
    }
 
    
}
