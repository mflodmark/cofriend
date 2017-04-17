//
//  AddScoreViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-11.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log

class AddScoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setViewLayout(view: self.view)
        createButtonArray()
        setDefaultTitles()
        setDefaultBackground()
        
        hidePicker()
        hideDatePicker()
        hideTextField()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Declarations
    @IBOutlet weak var scoreTitleButton: UIButton!
    @IBOutlet weak var yourImageButton: UIButton!
    @IBOutlet weak var friendImageButton: UIButton!
    @IBOutlet weak var doneOutletButton: UIButton!
    @IBOutlet weak var datePickerOutletButton: UIButton!
    @IBOutlet weak var yourScoreOutletButton: UIButton!
    @IBOutlet weak var friendScoreOutletButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldButton: UIButton!
    
    @IBOutlet weak var yourNameButton: UIButton!
    @IBOutlet weak var friendNameButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var exitOutletButton: UIButton!
    let screenSize = UIScreen.main.bounds
    var buttonArray = [UIButton]()
    
    // senderButton is used so that it is easy to know which button that created the last action
    var senderButton = UIButton()
    
    // MARK: Actions
    
    
    @IBAction func exitActionButton(_ sender: UIButton) {
        // Must check senderButton so that the exit button doesn't exit the modal view
        if senderButton != doneOutletButton {
            hidePicker()
            hideTextField()
            hideDatePicker()
            showButtons()
            animateWithDuration(time: 0.3)
        } else {
            if exitOutletButton.currentTitle == Titles.Exit.rawValue {
                // Exit modal view
                self.dismiss(animated: true, completion: nil)
            } else if exitOutletButton.currentTitle == Titles.Delete.rawValue {
                // If editing and pressing delete, remove from saved array
                addStoredData.remove(at: intForDateArray)
                saveData()
            }
        }
    }
    
    @IBAction func scoreTitleActionButton(_ sender: UIButton) {
        senderButton = sender
        hideButtons(sender: sender)
        showPicker(sender: sender)
        scoreTitleButton.setTitle(pickerDataArray[0], for: .normal)
        showTextField()
    }
    
    @IBAction func imageActionButton(_ sender: UIButton) {
        senderButton = sender
        yourImageButton.setTitle("", for: .normal)
        friendImageButton.setTitle("", for: .normal)
        hideButtons(sender: sender)

        // Must update text after picker is initialized
        showPicker(sender: sender)
        yourNameButton.setTitle(pickerDataArray[0], for: .normal)
        friendNameButton.setTitle(pickerDataArray[0], for: .normal)
        showTextField()
    }
    
    
    @IBAction func scoreActionButton(_ sender: UIButton) {
        senderButton = sender
        hideButtons(sender: sender)
        
        // Must update text after picker is initialized
        showPicker(sender: sender)
        yourScoreOutletButton.setTitle(pickerDataArray[0], for: .normal)
        friendScoreOutletButton.setTitle(pickerDataArray[0], for: .normal)
    }
    
    @IBAction func datePickerActionButton(_ sender: UIButton) {
        senderButton = sender
        hideButtons(sender: sender)

        // Must update text after picker is initialized
        showDatePicker()
        datePickerOutletButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
    }
    
    @IBAction func textFieldDoneActionButton(_ sender: UIButton) {
        // If text is added to texfField -> add text to pickerDataArray
        if textField.text != "" {
            if sender == scoreTitleButton {
                if let text = textField.text {
                    scoreTitleArray.append(text)
                    pickerDataArray.append(text)
                    print("PickerDataArray ----> \(pickerDataArray)")
                }
            } else {
                if let text = textField.text {
                    playerArray.append(Player(userName: text, userImage: #imageLiteral(resourceName: "DefaultImage")))
                    pickerDataArray.append(text)
                }
            }
        }

        
        // Reload pickerData
        picker.reloadAllComponents()
        
        // Make keybord disappear
        textField.resignFirstResponder()
    }
    
    
    @IBAction func doneActionButton(_ sender: UIButton) {
        // If senderButton was the last pressed button, thus meaning the user have just saved data 
        if senderButton == doneOutletButton {
            // Declarations
            var you: UIImage
            var friend: UIImage
            var scoreTitle: String
            var yourScore: Int
            var friendScore: Int
            var date: String
            var friendName: String
            var yourName: String
            
            // Save playerData
            if let yourImage = yourImageButton.backgroundImage(for: .normal), let friendImage = friendImageButton.backgroundImage(for: .normal), let title = scoreTitleButton.currentTitle, let youS = yourScoreOutletButton.currentTitle, let friendS = friendScoreOutletButton.currentTitle, let datePicker = datePickerOutletButton.currentTitle, let yourUserName = yourNameButton.currentTitle, let friendUserName = friendNameButton.currentTitle {
                
                // Result
                you = yourImage
                friend = friendImage
                scoreTitle = title
                yourScore = Int(youS)!
                friendScore = Int(friendS)!
                date = datePicker
                yourName = yourUserName
                friendName = friendUserName
                
                // Save scoreData
                if let addScore = StoredScoreData(scoreTitle: scoreTitle, yourScore: yourScore, friendScore: friendScore, yourImage: you, friendImage: friend, date: date, yourName: yourName, friendName: friendName) {
                    addStoredData.append(addScore)
                    
                    // Save data so that it is persistent
                    saveData()
                }
                
            } else {
                print("Something wrong when trying to save data")
            }
            
            // Exit modal view
            self.dismiss(animated: true, completion: nil)
            
        } else {
            hidePicker()
            hideTextField()
            hideDatePicker()
            showButtons()
            pressedButton()
        }
        
        // Update senderButton
        senderButton = sender
    }
    
    // MARK: Functions

    func showAlert(title: String) {
        let alertController = UIAlertController(title: "\(title)", message: "Add more details", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func createButtonArray() {
        // All buttons except the doneButton & the textfield/textfieldbutton
        buttonArray = [scoreTitleButton, datePickerOutletButton, yourScoreOutletButton, friendScoreOutletButton, yourImageButton, friendImageButton, yourNameButton, friendNameButton]
    }
    
    func hideButtons(sender: UIButton) {
        // Hide all buttons except doneButton & exitButton
        for eachButton in buttonArray {
            eachButton.isHidden = true
        }
        
        // Sender button should not be hidden
        if sender == yourImageButton || sender == friendImageButton || sender == yourNameButton || sender == friendNameButton {
            yourImageButton.isHidden = false
            yourNameButton.isHidden = false
            friendImageButton.isHidden = false
            friendNameButton.isHidden = false
            
        } else if sender == yourScoreOutletButton || sender == friendScoreOutletButton {
            friendNameButton.isHidden = false
            yourNameButton.isHidden = false
            yourScoreOutletButton.isHidden = false
            friendScoreOutletButton.isHidden = false
            
        } else {
            sender.isHidden = false
        }
        
        animateWithDuration(time: 0.8)
    }
    
    func animateWithDuration(time: Double) {
        // Animate with duration
        UIView.animate(withDuration: time) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showButtons() {
        for eachButton in buttonArray {
            eachButton.isHidden = false
        }
    }
    
    // Hide TextField and associated button
    func hideTextField() {
        textField.isHidden = true
        textFieldButton.isHidden = true
    }
    
    // Show TextField and associated button
    func showTextField() {
        textField.isHidden = false
        textFieldButton.isHidden = false
        textField.text = ""
        animateWithDuration(time: 0.8)
    }
    
    func setDefaultBackground() {
        // All buttons except doneButton
        for eachButton in buttonArray {
            setButtonLayout(eachButton: eachButton)
        }
        
        // Donebuttons
        setDoneButtonLayout(button: doneOutletButton)
        
        // ExitButton
        setExitButtonLayout(button: exitOutletButton)
        
        // TextFieldButton
        setTextFieldButtonLayout(button: textFieldButton)

    }
    
    
    func pressedButton() {
        // Change opacity
        senderButton.alpha = 0.6
    }
    
    var textToTextField = String()
    
    func setDefaultTitles() {
        scoreTitleButton.setTitle(Titles.Title.rawValue, for: .normal)
        yourImageButton.setTitle(Titles.YourImage.rawValue, for: .normal)
        friendImageButton.setTitle(Titles.FriendImage.rawValue, for: .normal)
        doneOutletButton.setTitle(Titles.Done.rawValue, for: .normal)
        datePickerOutletButton.setTitle(Titles.DatePicker.rawValue, for: .normal)
        yourScoreOutletButton.setTitle(Titles.YourScore.rawValue, for: .normal)
        friendScoreOutletButton.setTitle(Titles.FriendScore.rawValue, for: .normal)
        textFieldButton.setTitle("", for: .normal)
        textField.placeholder = "Add new element"
        yourNameButton.setTitle(Titles.YourUserId.rawValue, for: .normal)
        friendNameButton.setTitle(Titles.FriendUserId.rawValue, for: .normal)
        exitOutletButton.setTitle(Titles.Exit.rawValue, for: .normal)
        
    }

    
    // MARK: Picker
    
    // Declarations
    var pickerDataArray = [String]()
    var pickerColumns = Int()
    
    // Hide Picker
    func hidePicker() {
        picker.isHidden = true
        
        // Connect data
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    func hideDatePicker() {
        datePicker.isHidden = true
    }
    
    // Update Picker Data
    func updatePickerData(sender: UIButton) {
        if sender == scoreTitleButton {
            pickerColumns = 1
            pickerDataArray = scoreTitleArray
            
        } else if sender == yourImageButton || sender == friendImageButton || sender == yourNameButton || sender == friendNameButton {
            pickerColumns = 2
            pickerDataArray = []
            
            var i = 0
            while i < playerArray.count {
                pickerDataArray.append(playerArray[i].userName)
                i += 1
            }
            
        } else if sender == yourScoreOutletButton || sender == friendScoreOutletButton {
            pickerColumns = 2
            pickerDataArray = []
            
            // Loop to get the numbers to the pickerDataArray
            var i = 0
            while i <= 100 {
                pickerDataArray.append(String(i))
                i += 1
            }
            
        } else if sender == datePickerOutletButton {
            pickerColumns = 1
            showDatePicker()
        }
        
    }
    
    // Create datePicker
    func showDatePicker() {
        
        // Datepicker
        datePicker.isHidden = false
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.date
        
    }
    
    var dateFromDatePicker: Date? = nil
    var stringFromDatePicker: String? = ""
    let dateFormatter: DateFormatter = DateFormatter()

    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFromDatePicker = datePicker.date
        
        print("Date -------> " + dateFormatter.string(from: sender.date))
        
        stringFromDatePicker = dateFormatter.string(from: sender.date)
        datePickerOutletButton.setTitle(stringFromDatePicker, for: .normal)
        
    }
    
    // Show Picker
    func showPicker(sender: UIButton) {
        picker.isHidden = false
        updatePickerData(sender: sender)
        /*
        if sender == scoreTitleButton || sender == datePickerOutletButton {
            picker.selectRow(0, inComponent: 0, animated: true)
        } else {
            picker.selectRow(0, inComponent: 0, animated: true)
            picker.selectRow(0, inComponent: 1, animated: true)
        }*/
    }
    
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int {
        return pickerColumns
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataArray.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataArray[row]
    }
    
    // Update text on the buttons while scrolling
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if senderButton == scoreTitleButton {
            scoreTitleButton.setTitle(pickerDataArray[row], for: .normal)
            
        } else if senderButton == yourImageButton || senderButton == friendImageButton || senderButton == yourNameButton || senderButton == friendNameButton {
            
            if component == 0 {
                yourImageButton.setBackgroundImage(playerArray[row].userImage, for: .normal)
                yourNameButton.setTitle(playerArray[row].userName, for: .normal)
            } else if component == 1 {
                friendImageButton.setBackgroundImage(playerArray[row].userImage, for: .normal)
                friendNameButton.setTitle(playerArray[row].userName, for: .normal)
            }
            
        } else if senderButton == yourScoreOutletButton || senderButton == friendScoreOutletButton {
            
            if component == 0 {
                let firstColumn = pickerDataArray[row]
                yourScoreOutletButton.setTitle(String(firstColumn), for: .normal)
            } else if component == 1 {
                let secondColumn = pickerDataArray[row]
                friendScoreOutletButton.setTitle(String(secondColumn), for: .normal)
            }
            
        } else if senderButton == datePickerOutletButton {

        }
    }
    
    
    // MARK: NSCoding
    
    /*
     You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
     */
    
    private func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addStoredData, toFile: StoredScoreData.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    

    
    
}



