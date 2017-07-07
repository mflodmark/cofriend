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
import Charts

class DetailsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewLayout(view: self.view)
        

    }
    
    // MARK: Actions
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
