//
//  EditVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-22.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit


class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideFields()
        setLayout()
        
        // Connect data
        self.picker.delegate = self
        self.picker.dataSource = self
        
    }
    
    // MARK: Outlets
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var textFieldButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userOutletButton: UIButton!
    @IBOutlet weak var storedDataOutletButton: UIButton!
    @IBOutlet weak var gameTitleOutletButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func gameTitleActionButton(_ sender: UIButton) {
        showFields()
        senderButton = sender
        picker.reloadAllComponents()
    }
    
    @IBAction func userActionButton(_ sender: UIButton) {
        showFields()
        senderButton = sender
        picker.reloadAllComponents()
    }
    
    @IBAction func imageActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteActionButton(_ sender: UIButton) {
        
        showAlert(title: "Deleting Data", message: "Continue?", dismissButton: "Cancel", okButton: "Yes")
        
        picker.reloadAllComponents()
    }
    
    @IBAction func textFieldActionButton(_ sender: UIButton) {
        let row = picker.selectedRow(inComponent: 0)
        
        if let text = textField.text {
            if senderButton == gameTitleOutletButton {
                addScoreTitle[row].scoreTitle = text
            } else if senderButton == userOutletButton {
                addUserData[row].username = text
            }
        }

        picker.reloadAllComponents()
        textField.resignFirstResponder()
    }
    
    // MARK: Functions
    
    func alertOkFunctions() {
        let row = picker.selectedRow(inComponent: 0)

        if senderButton == gameTitleOutletButton {
            addScoreTitle.remove(at: row)
        } else if senderButton == userOutletButton {
            addUserData.remove(at: row)
        }
    }
    
    func alertDismissFunctions() {
        if senderButton == gameTitleOutletButton {
            // Don't do anything, just dismiss alert controller
        } else if senderButton == userOutletButton {
            
        }
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
    
    func setLayout() {
        setExitButtonLayout(button: deleteButton)
        setTextFieldButtonLayout(button: textFieldButton)
        setButtonLayout(eachButton: storedDataOutletButton)
        setButtonLayout(eachButton: gameTitleOutletButton)
        setButtonLayout(eachButton: userOutletButton)
    }
    
    func hideFields() {
        hide(button: deleteButton)
        hide(button: textFieldButton)
        hide(textField: textField)
        hide(picker: picker)
        hide(button: imageButton)
    }
    
    func showFields() {
        showField(button: deleteButton)
        showField(button: textFieldButton)
        showField(textField: textField)
        showField(picker: picker)
    }
    
    // MARK: Picker
    
    // Declarations
    var senderButton = UIButton()
    
    
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var counter = Int()
        
        if senderButton == gameTitleOutletButton {
            counter = addScoreTitle.count
            
        } else if senderButton == userOutletButton {
            counter = addUserData.count
            
        }
        
        return counter
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text = String()
        
        if senderButton == gameTitleOutletButton {
            text = addScoreTitle[row].scoreTitle
            
        } else if senderButton == userOutletButton {
            text = addUserData[row].username
            
        }
        
        return text
    }
    
    // Update text on the buttons while scrolling
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let text: String = "Delete "
        if senderButton == gameTitleOutletButton {
            // Must check count so that the app doesn't crash while scrolling nothing
            if addScoreTitle.count > 0 {
                let score = addScoreTitle[row].scoreTitle
                deleteButton.setTitle(text + score, for: .normal)
                textField.text = score
            }
        } else if senderButton == userOutletButton {
            // Must check count so that the app doesn't crash while scrolling nothing
            if addUserData.count > 0 {
                let user = addUserData[row].username
                imageButton.setBackgroundImage(addUserData[row].image, for: .normal)
                deleteButton.setTitle(text + user, for: .normal)
                textField.text = user
            }
        }
    }

    
    
    
}
