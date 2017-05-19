//
//  AddGameTitleVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class AddGameTitleVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonsToTextField(field: myTextField)
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
    }

    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    var keyBoardIsActive: Bool = false
    @IBOutlet weak var topConstraintOfTextFIeld: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        myTextField.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
    }
    
    // MARK: Actions

    
    // MARK: Functions
    

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
        prepareSavingData()
    }
    
    func prepareSavingData() {
        if let text = myTextField.text, let tournament = selectedTour?.tournamentTitle {
            let game = StoredGameTitleData(tournamentTitle: tournament, scoreTitle: text, id: idForGameTitle)
            
            addGameTitle.append(game!)
            
            // Save data
            saveGameTitleData()
            print("Saving game title!")
            
            // Dismiss view
            dismiss(animated: true, completion: nil)

            idForGameTitle += 1
            
            // Save id
            UserDefaults.standard.set(String(idForGameTitle), forKey: forKey.GameTitleId.rawValue)
        } else if myTextField.text == "" || myTextField.text == " " {
            showAlert(title: "Missing Title", message: "Plese Try Again", dismissButton: "Cancel", okButton: "Ok")
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
