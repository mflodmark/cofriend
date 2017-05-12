//
//  ScoreInsideCell.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-04.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class ScoreInsideCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initalixation code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected,animated: animated)
        
        //configure the view for selected state
    }
    
    // MARK: Properties
    
    @IBOutlet weak var teamAButton: UIButton!
    @IBOutlet weak var label: UILabel!
    

    @IBOutlet weak var teamBButton: UIButton!
    
    // MARK: Actions 
    
    
    @IBAction func teamAActionButton(_ sender: UIButton) {
    }
    
    @IBAction func teamBActionButton(_ sender: UIButton) {
    }
    
}

