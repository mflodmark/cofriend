
//
//  DetailsVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-06-27.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
//import Charts

class StatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //@IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setViewLayout(view: self.view)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        setMyArray()
        getPickerArrays()
        setSegmentedIndex()
        
        /*
         let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
         let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
         updateChartData()*/
        //setChart(dataPoints: months, values: unitsSold)
        
    }
    
    // MARK: Outlets
    
    var myArray: [UserClass] = []
    var myPickerArray: [String] = []
    var tournamentPicker: [String] = []
    var gamePicker: [String] = []
    var selectedTournament: String = ""
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    @IBOutlet weak var myPickerView: UIPickerView!
    
    // MARK: Actions
    
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        setSegmentedIndex()
    }
    
    
    // MARK: Functions
    
    func setMyArray() {
        
    }
    
    func setSegmentedIndex() {
        if mySegmentedControl.selectedSegmentIndex == 0 {
            myPickerArray = tournamentPicker
        } else {
            myPickerArray = gamePicker
        }
        myPickerView.reloadAllComponents()
        print(myPickerArray.count)
        print(tournamentPicker.count)

    }
    
    func setSegmentedIndexName(row: Int) {
        if mySegmentedControl.selectedSegmentIndex == 0 {
            // Name for tournament
            selectedTournament = myPickerArray[row]
        } else {
            // Name for game
        }
    }
    
    func getPickerArrays() {
        tournamentPicker = tournaments.map({$0.id!})
        print(tournaments.count)
        print(tournamentPicker.count)
        if selectedTournament != "" {
            let game = games.filter({$0.tournamentId! == selectedTournament})
            gamePicker = game.map({$0.id!})
        }
    }
    
    // MARK: Fetch data
    
    func fetchPoints() {
        
    }
    
    // MARK: - Table view data source
    
    //tells the table view how many sections to display.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.StatisticsCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailsCell
        
        // Fetches the appropriate data for the data source layout.
        let stats = myArray[indexPath.row]
        
        cell.nr.text = String(indexPath.row + 1)
        cell.name.text = stats.name
        
        
        return cell
    }
    
    // MARK: Pickerview
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return getNames(id: myPickerArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setSegmentedIndexName(row: row)
        getPickerArrays()
    }
    
    func getNames(id: String) -> String {
        var name: String = ""
        
        for each in games {
            if each.id == id {
                name = each.name!
            }
        }
        
        return name
    }
    

    
    // MARK: Chart
    /*
     func setChart(dataPoints: [String], values: [Double]) {
     
     var dataEntries: [ChartDataEntry] = []
     
     for i in 0..<dataPoints.count {
     let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
     dataEntries.append(dataEntry)
     }
     
     let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
     //let pieChartData = PieChartData(dataSets: pieChartDataSet)
     //PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
     //pieChartView.data = pieChartData
     
     var colors: [UIColor] = []
     
     for i in 0..<dataPoints.count {
     let red = Double(arc4random_uniform(256))
     let green = Double(arc4random_uniform(256))
     let blue = Double(arc4random_uniform(256))
     
     let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
     colors.append(color)
     }
     
     pieChartDataSet.colors = colors
     
     
     }
     func updateChartData()  {
     
     let chart = PieChartView(frame: self.view.frame)
     // 2. generate chart data entries
     let track = ["Income", "Expense", "Wallet", "Bank"]
     let money = [650, 456.13, 78.67, 856.52]
     
     var entries = [PieChartDataEntry]()
     for (index, value) in money.enumerated() {
     let entry = PieChartDataEntry()
     entry.y = value
     entry.label = track[index]
     entries.append( entry)
     }
     
     // 3. chart setup
     let set = PieChartDataSet( values: entries, label: "Pie Chart")
     // this is custom extension method. Download the code for more details.
     var colors: [UIColor] = []
     
     for _ in 0..<money.count {
     let red = Double(arc4random_uniform(256))
     let green = Double(arc4random_uniform(256))
     let blue = Double(arc4random_uniform(256))
     let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
     colors.append(color)
     }
     set.colors = colors
     let data = PieChartData(dataSet: set)
     chart.data = data
     chart.noDataText = "No data available"
     // user interaction
     chart.isUserInteractionEnabled = true
     
     let d = Description()
     d.text = "iOSCharts.io"
     chart.chartDescription = d
     chart.centerText = "Pie Chart"
     chart.holeRadiusPercent = 0.2
     chart.transparentCircleColor = UIColor.clear
     self.view.addSubview(chart)
     
     }*/
    
}


