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
        
        addButtonsToTextField(field: myTextField)
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
  
        
    }

    override func viewWillAppear(_ animated: Bool) {
        myTextField.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
    }
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    var keyBoardIsActive: Bool = false
    @IBOutlet weak var topConstraintOfTextFIeld: NSLayoutConstraint!
    

    
    @IBOutlet weak var pointsWin: UILabel!
    @IBOutlet weak var pointsDraw: UILabel!
    @IBOutlet weak var pointsLose: UILabel!
    @IBOutlet weak var winStepper: UIStepper!
    @IBOutlet weak var drawStepper: UIStepper!
    @IBOutlet weak var loseStepper: UIStepper!
    
    
    
    var win = 0
    var draw = 0
    var lose = 0
    
    // MARK: Actions

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
    
    // MARK: Functions
    
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
    }
    

    @objc func myTargetFunction() {
        // user touch field
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
            self.keyBoardIsActive = true
            self.topConstraintOfTextFIeld.constant = -200
        }

    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        if keyBoardIsActive == false {
            dismiss(animated: true, completion: nil)
        } else {
            myTextField.resignFirstResponder()
            keyBoardIsActive = false
            topConstraintOfTextFIeld.constant = -300
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
        dismiss(animated: true, completion: nil)
    }
    
    func doneClicked() {
        //prepareSavingData()
        saveNewGame()
        dismiss(animated: true, completion: nil)
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
                
            let post: [String : AnyObject] = ["name" : text as AnyObject, "createdByUserId": Auth.auth().currentUser?.uid as AnyObject]
            
            // Games -> Tournaments -> Id => post
            databaseRef.child("Games").child("Tournaments").child("\(tournamentId)").childByAutoId().setValue(post)
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
    
    
}
