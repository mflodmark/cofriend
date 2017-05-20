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
    var teamAArray: [StoredUserData] = [StoredUserData]()
    var teamBArray: [StoredUserData] = [StoredUserData]()


    
    // MARK: Actions 
    
    @IBAction func teamActionButton(_ sender: UIButton) {
        
        // Change background color
        if sender.backgroundColor == UIColor.orange {
            sender.backgroundColor = UIColor.white
        } else {
            sender.backgroundColor = UIColor.orange
        }
        
        // Add to array
        if sender == teamAButton {
            
        } else if sender == teamBButton {
            
        }
    }
    

    
    // Change to array, then let view chekc this value
    func returnButtonPressed() -> UIButton{
        return buttonPressed
    }
    
}

