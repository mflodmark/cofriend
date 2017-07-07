//
//  AddGameTitleVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class AddGameTitleVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sportButtons = [fifaButton, nhlButton]
        hideInactiveButtons()
        
        createTitles()
        stepperValues()
        addButtonsToTextField(field: myTextField)
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        setCenter()
        setUpPopUpButtons()
  
    }

    override func viewWillAppear(_ animated: Bool) {
        myTextField.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    var keyBoardIsActive: Bool = false
    

    
    @IBOutlet weak var pointsWin: UILabel!
    @IBOutlet weak var pointsDraw: UILabel!
    @IBOutlet weak var pointsLose: UILabel!
    @IBOutlet weak var winStepper: UIStepper!
    @IBOutlet weak var drawStepper: UIStepper!
    @IBOutlet weak var loseStepper: UIStepper!
    
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var tennisButton: UIButton!
    
    
    @IBOutlet weak var tableTennisButton: UIButton!
    @IBOutlet weak var badmintonButton: UIButton!
    @IBOutlet weak var nhlButton: UIButton!
    @IBOutlet weak var squashButton: UIButton!
    @IBOutlet weak var fifaButton: UIButton!
    
    
    
    var win = 0
    var draw = 0
    var lose = 0
    let popUpButtonColor = UIColor.clear
    
    // MARK: Actions
    @IBAction func doneButton(_ sender: UIButton) {
        saveNewGame()
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
        createPoints()
    }
    
    @IBAction func popUpButtonAction(_ sender: UIButton) {
        animatePopUpButton(sender: sender)

    }
    

    
    
    // MARK: Functions
    
    func hideInactiveButtons() {
        // Hidden buttons: 
        tennisButton.isHidden = true
        tableTennisButton.isHidden = true
        squashButton.isHidden = true
        badmintonButton.isHidden = true

    }
    
    func snow(image: UIImage) {
        let emitter = Emitter.get(image: image)
        emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 2.0)
        view.layer.addSublayer(emitter)
    }
    
    func animatePopUpButton(sender: UIButton) {
        if sender == popUpButton {
            bounce(button: sender)
            if sender.backgroundColor == popUpButtonColor {
                UIView.animate(withDuration: 0.3, animations: {
                    // Animations here
                    //self.tennisButton.center = self.tennisCenter
                    self.spreadOutButtons()
                })
                selectedPopUpButton(sender: sender)
                
            } else {
                
                UIView.animate(withDuration: 0.3, animations: {
                    // Animations here
                    self.setCenter()
                })
                
                setUpPopUpButtons()
                
            }
        } else {
            selectedPopUpButton(sender: sender)
            bounce(button: sender)
            setButtonTextToTextField(sender: sender)
            if let title = sender.title(for: .normal) {
                if let imageSet = UIImage(named: title) {
                    snow(image: imageSet)
                }
            }
        }
    }
    
    
    func bounce(button: UIButton) {
        // Make the label bounce
        button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            
            button.transform = CGAffineTransform.identity

        }, completion: nil)
    }
    
    func setButtonTextToTextField(sender: UIButton) {
        if let text = sender.title(for: .normal) {
            myTextField.text = "\(text)"
        }
    }
    
    var tennisCenter: CGPoint!
    var badmintonCenter: CGPoint!
    var fifaCenter: CGPoint!
    var nhlCenter: CGPoint!
    var squashCenter: CGPoint!
    var tableTennisCenter: CGPoint!
    var sportButtons: [UIButton] = []
    //var sportButtonsCenter: [CGPoint] = []


    
    func setCenter() {
        tennisCenter = tennisButton.center
        badmintonCenter = badmintonButton.center
        fifaCenter = fifaButton.center
        nhlCenter = nhlButton.center
        squashCenter = squashButton.center
        tableTennisCenter = tableTennisButton.center
        
        for each in sportButtons {
            each.translatesAutoresizingMaskIntoConstraints = true
            each.center = popUpButton.center
        }
        //tennisButton.translatesAutoresizingMaskIntoConstraints = true
        //tennisCenter = tennisButton.center

        //tennisButton.center = popUpButton.center
    }
    
    func spreadOutButtons() {
        tennisButton.center = tennisCenter
        badmintonButton.center = badmintonCenter
        squashButton.center = squashCenter
        nhlButton.center = nhlCenter
        fifaButton.center = fifaCenter
        tableTennisButton.center = tableTennisCenter

    }
    
    
    
    func setUpPopUpButtons() {
        // Layout for deselected button
        let popUp = [popUpButton, tennisButton, tableTennisButton, fifaButton, nhlButton, squashButton, badmintonButton]
        
        for each in popUp {
            each?.layer.borderWidth = 1
            each?.layer.borderColor = UIColor.orange.cgColor
            each?.layer.cornerRadius = 5
            each?.backgroundColor = UIColor.clear
            each?.setTitleColor(UIColor.orange, for: .normal)
        }

        
        for each in sportButtons {
            each.alpha = 0
        }
        
        
    }
    
    func selectedPopUpButton(sender: UIButton) {
        
        if sender.backgroundColor == popUpButtonColor {
            // Layout for selected button
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.backgroundColor = UIColor.orange
        } else if sender.backgroundColor == UIColor.orange {
            // Layout for deselected button
            sender.setTitleColor(UIColor.orange, for: .normal)
            sender.backgroundColor = popUpButtonColor
        }
        
        // Change backgroundcolor of all button except selected and popupbutton
        if sender != popUpButton {
            for each in sportButtons {
                if each != sender {
                    each.backgroundColor = popUpButtonColor
                }
            }
        }

        // Change alpha of all buttons except popupbutton
        if sender == popUpButton {
            for each in sportButtons {
                each.alpha = 1
            }
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

        if selectedGameCell == false {
            myTextField.text = ""
            
        } else if selectedGameCell == true {
            // Must divide them since update to 0 should only be for that specific one
            if let winText = selectedGame.winPoints {
                win = Int(winText)!
            } else {
                win = 0
            }
            
            if let loseText = selectedGame.losePoints {
                lose = Int(loseText)!
            } else {
                lose = 0
            }
            
            if let drawText = selectedGame.drawPoints {
                draw = Int(drawText)!
            } else {
                draw = 0
            }

            myTextField.text = selectedGame.name!
        }
        
        pointsWin.text = "Points for win: \(win)"
        pointsDraw.text = "Points for draw: \(draw)"
        pointsLose.text = "Points for lose: \(lose)"
        pointsWin.tintColor = UIColor.orange
        pointsDraw.tintColor = UIColor.orange
        pointsLose.tintColor = UIColor.orange
    }
    
    func createPoints() {
        pointsWin.text = "Points for win: \(win)"
        pointsDraw.text = "Points for draw: \(draw)"
        pointsLose.text = "Points for lose: \(lose)"
    }
    

    @objc func myTargetFunction() {
        // user touch field
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
            self.keyBoardIsActive = true
            //self.topConstraintOfTextFIeld.constant = -200
        }

    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        if keyBoardIsActive == false {
            dismiss(animated: true, completion: nil)
        } else {
            myTextField.resignFirstResponder()
            keyBoardIsActive = false
            //topConstraintOfTextFIeld.constant = -300
        }
    }
    
    // Done button added to textfield
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let toolBar = UIToolbar()
    
    
    func addButtonsToTextField(field: UITextField) {
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        field.inputAccessoryView = toolBar
        toolBar.sizeToFit()
    }
    
    func cancelClicked() {
        myTextField.resignFirstResponder()
        //dismiss(animated: true, completion: nil)
    }
    
    func doneClicked() {
        //prepareSavingData()
        myTextField.resignFirstResponder()

    }
    
    /*
    func prepareSavingData() {
        if myTextField.text == "" || myTextField.text == " " {
            showAlert(title: "Missing Title", message: "Plese Try Again", dismissButton: "Cancel", okButton: "Ok")
        } else if let text = myTextField.text, let tournament = selectedTour.name {
            let game = GameClass
            
            games.append(game!)
            
            // Save data
            /7saveGameTitleData()
            print("Saving game title!")
            
            //idForGameTitle += 1
            
            // Save id
            //UserDefaults.standard.set(String(idForGameTitle), forKey: forKey.GameTitleId.rawValue)
            
            // Dismiss view
        }
    }*/
    
    func saveNewGame() {
        
        if myTextField.text == "" || myTextField.text == " " {
            showAlert(title: "Missing Title", message: "Plese Try Again", dismissButton: "Cancel", okButton: "Ok")
        } else if let text = myTextField.text, let tournamentId = selectedTour.id {
        
            var databaseRef: DatabaseReference!
            databaseRef = Database.database().reference()
            let newRef = databaseRef.child("Games").child("Tournaments").child("\(tournamentId)").childByAutoId()
            
            let post: [String : AnyObject] = ["name" : text as AnyObject, "createdByUserId": Auth.auth().currentUser?.uid as AnyObject, "winPoints" : String(win) as AnyObject, "drawPoints" : String(draw) as AnyObject, "losePoints" : String(lose) as AnyObject]
            
            // Games -> Tournaments -> Id => post
            if selectedGameCell == false {
                newRef.setValue(post)
            } else if selectedGameCell == true {
                // Edit
                if let selId = selectedGame.id {
                    databaseRef.child("Games/Tournaments/\(tournamentId)/\(selId)").setValue(post)
                }
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
            self.alertOkFunctions()
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            self.alertDismissFunctions()
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
}
