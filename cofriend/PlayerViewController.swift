//
//  PlayerViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class PlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setViewLayout(view: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Declarations
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var scoreTable: UILabel!
    @IBOutlet weak var scoreHeadingLabel: UILabel!
    
    
    // Actions
    
    
}
