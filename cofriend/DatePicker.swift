//
//  DatePicker.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-18.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class DatePickerClass: UIViewController {
    
    override func viewDidLoad() {
        showDatePicker()
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
    }
    

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //let scoreInsideTourVC = ScoreInsideTourVC()
    
    @IBAction func dismissView(_ sender: UIButton) {
        // Keep the last used date
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelActionButton(_ sender: UIButton) {
        // Keep the last used date
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneActionButton(_ sender: UIButton) {
        // Save data
        if let date = self.stringFromDatePicker {
            dateString = date
            //self.scoreInsideTourVC.addTodaysDate()
        }
        
        dismiss(animated: true, completion: {
            

            
            /*
            let sb = UIStoryboard(name: identifiersStoryboard.DatePicker.rawValue, bundle: nil)
            
            if let scoreInside = sb.instantiateViewController(withIdentifier: identifiersStoryboard.Score.rawValue) as? ScoreInsideTourVC {
                
                scoreInside.dateButton.setTitle("Hello", for: .normal)
            }*/
            
        })
    }
    
    // Create datePicker
    func showDatePicker() {
        
        // Datepicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.date
        
    }
    
    var dateFromDatePicker: Date? = nil
    var stringFromDatePicker: String? = "No Date Available"
    let dateFormatter: DateFormatter = DateFormatter()
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFromDatePicker = datePicker.date
        
        print("Date -------> " + dateFormatter.string(from: sender.date))
        
        stringFromDatePicker = dateFormatter.string(from: sender.date)
        
    }
    

    
    func returnDate() -> String {
        if let text = stringFromDatePicker {
            return text
        } else {
            return "No Date Available"
        }
    }
    

    
}
