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
    var buttonPressed: UIButton = UIButton()

    
    // MARK: Actions 
    
    @IBAction func teamAActionButton(_ sender: UIButton) {
        buttonPressed = sender
        teamAButton.backgroundColor = UIColor.orange
        // Add to array
    }
    
    @IBAction func teamBActionButton(_ sender: UIButton) {
        buttonPressed = sender
        teamAButton.backgroundColor = UIColor.orange

    }
    
    // Change to array, then let view chekc this value
    func returnButtonPressed() -> UIButton{
        return buttonPressed
    }
    
}

