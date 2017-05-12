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
        
        createButtonArray()
        setDefaultTitles()
        setDefaultBackground()
        getIdForSavedData()
        
        hidePicker()
        hideDatePicker()
        hideTextField()
        
        if identifiedSegue == identifiersSegue.AddToAddScore.rawValue {
            hideDeleteButton()
        } else {
            setTitlesForEdit()
        }
        
        getIdForSavedData()
        
        initSenderButton()
        loadAnySavedData()

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
    @IBOutlet weak var deleteButton: UIButton!
    
    
    let screenSize = UIScreen.main.bounds
    var buttonArray = [UIButton]()

    
    // senderButton is used so that it is easy to know which button that created the last action
    var senderButton = UIButton()
    
    // MARK: Actions
    
    @IBAction func deleteActionButton(_ sender: UIButton) {
        
        showAlert(title: "Deleting saved data", message: "Continue?", dismissButton: "No", okButton: "Yes", sender: deleteButton)

    }
    
    
    @IBAction func exitActionButton(_ sender: UIButton) {
        // Must check senderButton so that the exit button doesn't exit the modal view
        if senderButton == doneOutletButton || senderButton == exitOutletButton {
            // Exit modal view
            self.dismiss(animated: true, completion: nil)

        } else {
            // FIXME: values are added to the buttons instead of keeping the default value
            hidePicker()
            hideTextField()
            hideDatePicker()
            showButtons()
            animateWithDuration(time: 0.3)
        }
        
        senderButton = sender
    }
    
    @IBAction func scoreTitleActionButton(_ sender: UIButton) {
        senderButton = sender
        hideButtons(sender: sender)
        showPicker(sender: sender)
        
        selectScoreTitle()
        
        showTextField()
    }
    

    
    
    @IBAction func imageActionButton(_ sender: UIButton) {
        senderButton = sender
        yourImageButton.setTitle("", for: .normal)
        friendImageButton.setTitle("", for: .normal)
        hideButtons(sender: sender)

        // Must update text after picker is initialized
        showPicker(sender: sender)
        getUserDataTitle()
        showTextField()

    }
    

    
    @IBAction func scoreActionButton(_ sender: UIButton) {
        senderButton = sender
        hideButtons(sender: sender)
        
        // Must update text after picker is initialized
        showPicker(sender: sender)
        
        if yourScoreOutletButton.title(for: .normal) == Titles.YourScore.rawValue || friendScoreOutletButton.title(for: .normal) == Titles.FriendScore.rawValue {
            // Add new score
            yourScoreOutletButton.setTitle(pickerDataArray[0], for: .normal)
            friendScoreOutletButton.setTitle(pickerDataArray[0], for: .normal)
        }
    }
    
    @IBAction func datePickerActionButton(_ sender: UIButton) {
        senderButton = sender
        hideButtons(sender: sender)

        // Must update text after picker is initialized
        showDatePicker()
        datePickerOutletButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
    }
    
    
    @IBAction func textFieldDoneActionButton(_ sender: UIButton) {
        
        // If text is added to texfField -> add text to pickers
        if let text = textField.text {
            if text != "" {
                if senderButton == scoreTitleButton {
                checkTitleAndSaveTitleData(text: text)
            } else {
                checkUserAndSaveUserData(text: text)
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
            savingDataAfterCheckingValues()
        } else {
            hidePicker()
            hideTextField()
            hideDatePicker()
            showButtons()
            animateWithDuration(time: 0.5)
            //FIXME: pressed button needs to be better
            pressedButton()
        }
        
        // Update senderButton
        senderButton = sender
    }
    
    // MARK: Functions
    
    
    func getUserDataTitle() {
        if addUserData.count > 0 {
            if yourNameButton.title(for: .normal) == Titles.FriendUserId.rawValue || friendNameButton.title(for: .normal) == Titles.FriendUserId.rawValue {
                // Add new score
                yourNameButton.setTitle(addUserData[0].username, for: .normal)
                friendNameButton.setTitle(addUserData[0].username, for: .normal)
            }
        }
    }
    
    /*
    func getDataFromScoreArrayAndSetTitle() {
        if let yourScore = yourScoreOutletButton.title(for: .normal), let friendScore = friendScoreOutletButton.title(for: .normal) {
            
            yourScoreOutletButton.setTitle(yourScore, for: .normal)
            friendScoreOutletButton.setTitle(friendScore, for: .normal)
        }
    }*/
    
    /*
    func getDataFromUserArrayAndSetTitle() {
        var counter = 0
        for _ in addUserData {
            if yourNameButton.title(for: .normal) == addUserData[counter].username {
                yourNameButton.setTitle(addUserData[counter].username, for: .normal)
            }
            if friendNameButton.title(for: .normal) == addUserData[counter].username {
                friendNameButton.setTitle(addUserData[counter].username, for: .normal)
            }
            counter += 1
        }
    }*/
    

    
    
    func checkUserAndSaveUserData(text: String) {
        if checkUsername(text: text) == true {
            showAlert(title: "Username already exist", message: "Please try again", dismissButton: "Cancel", okButton: "Ok", sender: yourImageButton)
        } else {
            if let user = StoredUserData(username: text, image: #imageLiteral(resourceName: "DefaultImage"), id: idForUserData) {
                
                addUserData.append(user)
                saveUserData()
                idForUserData += 1
                
                // Save id
                UserDefaults.standard.set(String(idForUserData), forKey: forKey.UsernameDataId.rawValue)
                
                // Select row
                picker.selectRow(addUserData.count - 1, inComponent: 0, animated: true)
                
            }
        }
    }
    
    func checkTitleAndSaveTitleData(text: String) {
        if checkTitle(text: text) == true {
            
            showAlert(title: "Game title already exist", message: "Please try again", dismissButton: "Cancel", okButton: "Ok", sender: scoreTitleButton)
            
        } else {
            // Add text to score title array
            if let add = StoredTitleData(scoreTitle: text, id: idForTitleData) {
                
                addScoreTitle.append(add)
                saveScoreTitleData()
                idForTitleData += 1
                
                // Save id
                UserDefaults.standard.set(String(idForTitleData), forKey: forKey.GameTitleDataId.rawValue)
                
                // Select row
                picker.selectRow(addScoreTitle.count - 1, inComponent: 0, animated: true)
                print("ScoreTitleArray ----> \(addScoreTitle.count)")
            }
        }
    }
    


    func savingDataAfterCheckingValues() {
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
            date = datePicker
            yourName = yourUserName
            friendName = friendUserName
            
            // Check if title remains as default
            if youS == Titles.YourScore.rawValue || friendS == Titles.FriendScore.rawValue || scoreTitle == Titles.Title.rawValue || date == Titles.DatePicker.rawValue || yourName == Titles.YourUserId.rawValue || friendName == Titles.FriendUserId.rawValue {
                
                // alert to show that something is wrong
                showAlert(title: "No Score Added", message: "Pleae try again", dismissButton: "Cancel", okButton: "Ok", sender: yourScoreOutletButton)
                
            } else {
                // Save data if text is not as default
                
                // Result of unwrapping and Id
                yourScore = Int(youS)!
                friendScore = Int(friendS)!
                id += 1
                
                // Save id
                UserDefaults.standard.set(String(id), forKey: forKey.ScoreDataId.rawValue)
                
                // Save scoreData
                if let addScore = StoredScoreData(scoreTitle: scoreTitle, yourScore: yourScore, friendScore: friendScore, yourImage: you, friendImage: friend, date: date, yourName: yourName, friendName: friendName, id: id) {
                    addStoredData.append(addScore)
                    
                    // Save data so that it is persistent
                    saveData()
                    
                    // Exit modal view
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    print("Something wrong when trying to save data")
                }
            }
        }
    }
    
    func selectScoreTitle() {
        if addScoreTitle.count > 0 {
            if scoreTitleButton.title(for: .normal) == Titles.Title.rawValue {
                // select default title
                scoreTitleButton.setTitle(addScoreTitle[0].scoreTitle, for: .normal)
            } else {
                var counter: Int = 0
                for data in addScoreTitle {
                    if data.scoreTitle == scoreTitleButton.title(for: .normal) {
                        // select title
                        scoreTitleButton.setTitle(addScoreTitle[counter].scoreTitle, for: .normal)
                    } else {
                        
                    }
                    counter += 1
                }
            }
        }
    }
    
    
    func loadAnySavedData() {
        if addUserData.count == 0 {
            // Load any saved data, otherwise load default.
            if let savedData = loadUserData() {
            addUserData += savedData
            }
        }

    }
    
    func checkUsername(text: String) -> Bool {
        // starter value
        var checked = false
        for user in addUserData {
            if text == user.username {
                // Username already exists
                checked = true
            }
        }
        return checked
    }
    
    func checkTitle(text: String) -> Bool {
        // starter value
        var checked = false
        for title in addScoreTitle {
            if text == title.scoreTitle {
                // Username already exists
                checked = true
            }
        }
        return checked
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
    
    func initSenderButton() {
        senderButton = exitOutletButton
    }
    
    func alertOkFunctions(sender: UIButton) {
        if sender == deleteButton {
            if let index = checkSelectedIdPositionInArray(id: selectedId) {
                addStoredData.remove(at: index)
                
                saveData()
                animateWithDuration(time: 0.3)
                self.dismiss(animated: true, completion: nil)
            }
        } else if sender == scoreTitleButton {
            
        } else if sender == yourImageButton {
            
        }
    }
    
    func alertDismissFunctions(sender: UIButton) {
        if sender == deleteButton {
            // Don't do anything, just dismiss alert controller
        } else if sender == scoreTitleButton {
    
        } else if sender == yourImageButton {
    
        }
    }

    func showAlert(title: String, message: String, dismissButton: String, okButton: String, sender: UIButton) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.alertOkFunctions(sender: sender)
        
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel logic here")
            self.alertDismissFunctions(sender: sender)
            
        })
        alertController.addAction(actionCancel)
        
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
        
        // ExitButton & deleteButton
        setExitButtonLayout(button: exitOutletButton)
        setExitButtonLayout(button: deleteButton)
        
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
        yourImageButton.setBackgroundImage(#imageLiteral(resourceName: "DefaultImage"), for: .normal)
        friendImageButton.setBackgroundImage(#imageLiteral(resourceName: "DefaultImage"), for: .normal)
        yourImageButton.setTitle("", for: .normal)
        friendImageButton.setTitle("", for: .normal)
        doneOutletButton.setTitle(Titles.Done.rawValue, for: .normal)
        datePickerOutletButton.setTitle(Titles.DatePicker.rawValue, for: .normal)
        yourScoreOutletButton.setTitle(Titles.YourScore.rawValue, for: .normal)
        friendScoreOutletButton.setTitle(Titles.FriendScore.rawValue, for: .normal)
        textFieldButton.setTitle("", for: .normal)
        textField.placeholder = "Add new element"
        yourNameButton.setTitle(Titles.YourUserId.rawValue, for: .normal)
        friendNameButton.setTitle(Titles.FriendUserId.rawValue, for: .normal)
        exitOutletButton.setTitle(Titles.Exit.rawValue, for: .normal)
        deleteButton.setTitle(Titles.Delete.rawValue, for: .normal)
    }
    
    func setTitlesForEdit() {
        // Get position for selectedId
        if let id = checkSelectedIdPositionInArray(id: selectedId) {
            // Titles of saved data
            scoreTitleButton.setTitle(addStoredData[id].scoreTitle, for: .normal)
            yourImageButton.setBackgroundImage(addStoredData[id].yourImage, for: .normal)
            friendImageButton.setBackgroundImage(addStoredData[id].friendImage, for: .normal)
            yourImageButton.setTitle("", for: .normal)
            friendImageButton.setTitle("", for: .normal)
            doneOutletButton.setTitle(Titles.Done.rawValue, for: .normal)
            datePickerOutletButton.setTitle(addStoredData[id].date, for: .normal)
            yourScoreOutletButton.setTitle(String(addStoredData[id].yourScore), for: .normal)
            friendScoreOutletButton.setTitle(String(addStoredData[id].friendScore), for: .normal)
            textFieldButton.setTitle("", for: .normal)
            textField.placeholder = "Add new element"
            yourNameButton.setTitle(addStoredData[id].yourName, for: .normal)
            friendNameButton.setTitle(addStoredData[id].friendName, for: .normal)
            exitOutletButton.setTitle(Titles.Exit.rawValue, for: .normal)
            deleteButton.setTitle(Titles.Delete.rawValue, for: .normal)
        }
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
    
    
    // Update Picker Data
    func updatePickerData(sender: UIButton) {
        if sender == scoreTitleButton {
            pickerColumns = 1
            
        } else if sender == yourImageButton || sender == friendImageButton || sender == yourNameButton || sender == friendNameButton {
            
            pickerColumns = 2
            
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
        var counter = Int()
        
        if senderButton == scoreTitleButton {
            
            counter = addScoreTitle.count
            
        } else if senderButton == yourImageButton || senderButton == friendImageButton || senderButton == yourNameButton || senderButton == friendNameButton {
            
            counter = addUserData.count
            
        } else if senderButton == yourScoreOutletButton || senderButton == friendScoreOutletButton {
            
            counter = pickerDataArray.count
            
        }
        
        return counter
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text = String()
        
        if senderButton == scoreTitleButton {
            
            text = addScoreTitle[row].scoreTitle
            
        } else if senderButton == yourImageButton || senderButton == friendImageButton || senderButton == yourNameButton || senderButton == friendNameButton {
            
            text = addUserData[row].username

        } else if senderButton == yourScoreOutletButton || senderButton == friendScoreOutletButton {
            
            text = pickerDataArray[row]
            
        }
        
        return text
    }
    
    // Update text on the buttons while scrolling
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if senderButton == scoreTitleButton {
            // Must check count so that the app doesn't crash while scrolling nothing
            if addScoreTitle.count > 0 {
                scoreTitleButton.setTitle(addScoreTitle[row].scoreTitle, for: .normal)
            }
        } else if senderButton == yourImageButton || senderButton == friendImageButton || senderButton == yourNameButton || senderButton == friendNameButton {
            // Must check count so that the app doesn't crash while scrolling nothing
            if addUserData.count > 0 {
                if component == 0 {
                    yourImageButton.setBackgroundImage(addUserData[row].image, for: .normal)
                    yourNameButton.setTitle(addUserData[row].username, for: .normal)
                    
                } else if component == 1 {
                    friendImageButton.setBackgroundImage(addUserData[row].image, for: .normal)
                    friendNameButton.setTitle(addUserData[row].username, for: .normal)
                }
            }
        } else if senderButton == yourScoreOutletButton || senderButton == friendScoreOutletButton {
            // Must check count so that the app doesn't crash while scrolling nothing
            if pickerDataArray.count > 0 {
                if component == 0 {
                    let firstColumn = pickerDataArray[row]
                    yourScoreOutletButton.setTitle(String(firstColumn), for: .normal)
                    
                } else if component == 1 {
                    let secondColumn = pickerDataArray[row]
                    friendScoreOutletButton.setTitle(String(secondColumn), for: .normal)
                }
            }
        } else if senderButton == datePickerOutletButton {

        }
    }
    
    // MARK: Datepicker

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
    
    func hideDatePicker() {
        datePicker.isHidden = true
    }
    
    
}

// FIXME: add todays date as title. 
// FIXME: after adding username, add image



