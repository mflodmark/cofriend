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

        setViewLayout(view: self.view)
        
        // Load any saved data, otherwise load default.
        if let savedData = loadData() {
            addStoredData += savedData
        } else {
            loadDefaultData()
        }
        
        // Layout for buttons
        createButtonArray()
        setDefaultBackground()
        
        // Data for buttons
        addDataToOutlets(dataSet: 0)
        
        //disableButtons()
        
        // Creat array to show all added dates
        createDatePickerArray()
        
        // Connect data
        self.datePicker.delegate = self
        self.datePicker.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Declarations
    
    @IBOutlet weak var scoreTitle: UIButton!
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
    
    func setDefaultBackground() {
        for eachButton in buttonArray {
            setButtonLayout(eachButton: eachButton)
        }
    }
    
    func loadDefaultData() {
        let addScore = StoredScoreData(scoreTitle: "Game Title", yourScore: 0, friendScore: 0, yourImage: UIImage(named: Images.Default.rawValue)!, friendImage: UIImage(named: Images.Default.rawValue)!, date: "1900-01-01", yourName: "You", friendName: "Friend")
        addStoredData.append(addScore!)
    }
    
    func addDataToOutlets(dataSet: Int) {
        //navigationItem.title = addStoredData[dataSet].scoreTitle
        scoreTitle.setTitle(addStoredData[dataSet].scoreTitle, for: .normal)
        yourImage.setBackgroundImage(addStoredData[dataSet].yourImage, for: .normal)
        yourImage.setTitle("", for: .normal)
        friendImage.setBackgroundImage(addStoredData[dataSet].friendImage, for: .normal)
        friendImage.setTitle("", for: .normal)
        yourScore.setTitle(String(addStoredData[dataSet].yourScore), for: .normal)
        friendScore.setTitle(String(addStoredData[dataSet].friendScore), for: .normal)
        yourName.setTitle(addStoredData[dataSet].yourName, for: .normal)
        friendName.setTitle(addStoredData[dataSet].friendName, for: .normal)
    }
    
    
    
    func createButtonArray() {
        buttonArray = [scoreTitle, yourImage, friendImage, yourScore, friendScore, yourName, friendName]
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
    
    // MARK: NSCoding
    
    private func loadData() -> [StoredScoreData]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: StoredScoreData.ArchiveURL.path) as? [StoredScoreData]
    }
    
    // MARK: Segues
    
    override func viewDidAppear(_ animated: Bool) {
        
        let counter = addStoredData.count - 1
        addDataToOutlets(dataSet: counter)
        createDatePickerArray()
        
        // Reload pickerData
        datePicker.reloadAllComponents()
        
        print("Counting stored data -----> \(addStoredData.count)")
    }
    
    // MARK: Picker
    
    // Declarations
    var datePickerArray = [String]()
    var pickerDataArray = [String]()
    var titlePickerArray = [String]()
    var counter = Int()
    
    // Create date picker
    func createDatePickerArray() {
        pickerDataArray = []
        for each in addStoredData {
            pickerDataArray.append(each.date)
        }
        datePicker.selectRow(pickerDataArray.count - 1, inComponent: 0, animated: true)

        print("Counting picker data -----> \(pickerDataArray.count)")
    }
        
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == datePicker {
            counter = pickerDataArray.count
        } else if pickerView == titlePicker {
            counter = titlePickerArray.count
        }
        return counter
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataArray[row]
    }
    
    // Update text on the buttons while scrolling
    func pickerView(_ pickerView: UIDatePicker, didSelectRow row: Int, inComponent component: Int) {
        // Add position of array to a variable so that deleting is working
        intForDateArray = row
        addDataToOutlets(dataSet: row)
    }
}



