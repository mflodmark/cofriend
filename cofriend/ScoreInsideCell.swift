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
    var user: StoredUserData = StoredUserData(username: "", image: #imageLiteral(resourceName: "Default"), id: 0)!

    
    // MARK: Actions 
    
    @IBAction func teamActionButton(_ sender: UIButton) {
        
        
        // Change background color
        if teamAButton.alpha == 0.5 && teamBButton.alpha == 0.5 {
            
            // Add to array
            if sender == teamAButton && teamOneArray.count < 2 {
                teamOneArray.append(user)
                sender.alpha = 1.0
                print("Added user -------> " + user.username)
            } else if sender == teamBButton && teamTwoArray.count < 2 {
                teamTwoArray.append(user)
                sender.alpha = 1.0
            }
            
        } else if sender.alpha == 1.0 {
            sender.alpha = 0.5
            
            // Remove from array
            if sender == teamAButton {
                // Check position
                if let position = checkPositionInArray(id: user.id, array: teamOneArray) {                                    teamOneArray.remove(at: position)
                }
            } else if sender == teamBButton {
                // Check position
                if let position = checkPositionInArray(id: user.id, array: teamTwoArray) {
                    teamTwoArray.remove(at: position)

                }
            }
        }
    }
    
    func checkPositionInArray(id: Int, array: [StoredUserData]) -> Int? {
        // starter value
        var checked = Int()
        var counter: Int = 0
        for user in array {
            print("UserId -----> \(user.id) ")
            if id == user.id {
                // Selected user
                checked = counter
            }
            counter += 1
        }
        return checked
    }
}

