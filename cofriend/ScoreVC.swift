//
//  ScoreViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class ScoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadAnySavedData()
        
        // Layout for buttons
        createButtonArray()
        setDefaultBackground()
        
        // Data for buttons
        addDataToOutlets(dataSet: 0)
        
        //disableButtons()
        
        // Creat array to show data
        createTitlePickerArray()
        
        // Connect data
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        self.titlePicker.delegate = self
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let counter = addStoredData.count - 1
        addDataToOutlets(dataSet: counter)
        createTitlePickerArray()
        
        // Reload picker
        datePicker.reloadAllComponents()
        
        print("Counting stored score data -----> \(addStoredData.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Declarations
    
    @IBOutlet weak var yourImage: UIButton!
    @IBOutlet weak var friendImage: UIButton!
    @IBOutlet weak var yourScore: UIButton!
    @IBOutlet weak var friendScore: UIButton!
    @IBOutlet weak var yourName: UIButton!
    @IBOutlet weak var friendName: UIButton!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var titlePicker: UIPickerView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var buttonArray = [UIButton]()

    
    // MARK: Functions
    
    func loadAnySavedData() {
        // Load any saved data, otherwise load default.
        addStoredData = []
        if let savedData = loadData() {
            addStoredData += savedData
        } else {
            loadDefaultData()
        }

        // Load score title data
        if addScoreTitle.count == 0 {
            if let savedData = loadScoreTitleData() {
                addScoreTitle += savedData
            }
        }
    }
    
    func setDefaultBackground() {
        for eachButton in buttonArray {
            setButtonLayout(eachButton: eachButton)
        }
    }
    
    func loadDefaultData() {
        let addScore = StoredScoreData(scoreTitle: "Game Title", yourScore: 0, friendScore: 0, yourImage: UIImage(named: Images.Default.rawValue)!, friendImage: UIImage(named: Images.Default.rawValue)!, date: "1900-01-01", yourName: "You", friendName: "Friend", id: 0)
        addStoredData.append(addScore!)
    }
    
    

    func addDataToOutlets(dataSet: Int) {
        // First stored data will appear as data if the id isn't found in the stored data111
        var addData: StoredScoreData = addStoredData[0] // init
        
        
        // loop to get the correct integer from the array when comparing to the sending id
        for data in addStoredData {
            if dataSet == data.id {
                addData = data
            }
        }
        
        yourImage.setBackgroundImage(addData.yourImage, for: .normal)
        yourImage.setTitle("", for: .normal)
        friendImage.setBackgroundImage(addData.friendImage, for: .normal)
        friendImage.setTitle("", for: .normal)
        yourScore.setTitle(String(addData.yourScore), for: .normal)
        friendScore.setTitle(String(addData.friendScore), for: .normal)
        yourName.setTitle(addData.yourName, for: .normal)
        friendName.setTitle(addData.friendName, for: .normal)
        
    }
    
    
    
    func createButtonArray() {
        buttonArray = [yourImage, friendImage, yourScore, friendScore, yourName, friendName]
    }
    
    func enableButtons() {
        for eachButton in buttonArray {
            eachButton.isEnabled = true
        }
    }
    
    func disableButtons() {
        for eachButton in buttonArray {
            eachButton.isEnabled = false
        }
    }
    
    func setDefaultTitleIfNoSavedData() {
        yourImage.setBackgroundImage(#imageLiteral(resourceName: "DefaultImage"), for: .normal)
        yourImage.setTitle("", for: .normal)
        friendImage.setBackgroundImage(#imageLiteral(resourceName: "DefaultImage"), for: .normal)
        friendImage.setTitle("", for: .normal)
        yourScore.setTitle(String("No saved data"), for: .normal)
        friendScore.setTitle(String("No saved data"), for: .normal)
        yourName.setTitle("No saved data", for: .normal)
        friendName.setTitle("No saved data", for: .normal)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifiersSegue.AddToAddScore.rawValue {
            identifiedSegue = identifiersSegue.AddToAddScore.rawValue
        } else if segue.identifier == identifiersSegue.EditToAddScore.rawValue {
            identifiedSegue = identifiersSegue.EditToAddScore.rawValue
        }
    }
    

    
    // MARK: Picker
        
    // Declarations
    var datePickerArray = [StoredScoreData]()
    var titlePickerArray = [String]()
    var counter = Int()
    var text = String()
    
    // Create titlepicker
    func createTitlePickerArray() {
        titlePickerArray = []
        for each in addScoreTitle {
            titlePickerArray.append(each.scoreTitle)
        }
        
        
        if titlePickerArray.count > 0 {
            // Init selected title
            createDatePickerArray(title: titlePickerArray[0])
        }
        
        titlePicker.reloadAllComponents()
        titlePicker.selectRow(0, inComponent: 0, animated: true)
        
        titlePicker.reloadAllComponents()
        print("Counting titlePicker data -----> \(titlePickerArray.count)")
    }
    
    // Create date picker
    func createDatePickerArray(title: String) {
        datePickerArray = []
        for each in addStoredData {
            if title == each.scoreTitle {
                datePickerArray.append(each)
            }
        }
        
        // No data available for this title, thus setting default titles
        if datePickerArray == [] {
            setDefaultTitleIfNoSavedData()
            datePicker.reloadAllComponents()
        } else {
            datePicker.reloadAllComponents()
            datePicker.selectRow(datePickerArray.count - 1, inComponent: 0, animated: true)
            // Update outlets
            selectedId = datePickerArray[datePickerArray.count - 1].id
            print("SelectedId ------> \(selectedId)")
            addDataToOutlets(dataSet: selectedId)
        }
        
        print("Counting datePicker data -----> \(datePickerArray.count)")
    }
        
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == datePicker {
            counter = datePickerArray.count
        } else if pickerView == titlePicker {
            counter = titlePickerArray.count
        }
        return counter
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == datePicker {
            text = datePickerArray[row].date
        } else if pickerView == titlePicker {
            text = titlePickerArray[row]
        }
        return text
    }
    
    // Update text on the buttons while scrolling
    func pickerView(_ pickerView: UIDatePicker, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == datePicker {
            if datePickerArray.count > 0 {
                selectedId = datePickerArray[row].id
                addDataToOutlets(dataSet: selectedId)
                print("SelectedId ------> \(selectedId)")
            }
        } else if pickerView == titlePicker {
            if titlePickerArray.count > 0 {
                selectedTitle = titlePickerArray[row]
                createDatePickerArray(title: selectedTitle)
                print("SelectedTitle ------> \(selectedTitle)")
            }
        }
    }
}



