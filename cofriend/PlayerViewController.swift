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
        
        getPlayer()
        getScoreData()
        addPointsToLabels()
        addPercentToLabels()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Declarations
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winScoreLabel: UILabel!
    @IBOutlet weak var winPercentLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var drawScoreLabel: UILabel!
    @IBOutlet weak var drawPercentLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var loseScoreLabel: UILabel!
    @IBOutlet weak var losePercentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    let user = (UserDefaults.standard.value(forKey: forKey.Username.rawValue) as? String)
    var pointsWin = 0
    var pointsDraw = 0
    var pointsLose = 0
    var pointsTotal = Int()
    var percentWin = 0.00
    var percentDraw = 0.00
    var percentLose = 0.00
    
    // MARK: Actions
    
    // MARK: Functions
    
    func getPlayer() {
        if user == nil {
            // Don't do anything yet
        
        } else {
            // Load Player data
            let name = addUserData[0].username
            playerName.text = name
            
            let image = addUserData[0].image
            playerImage.image = image
        }
        
    }
    
    func getScoreData() {
        for each in addStoredData {
            // check if userName has any stored data
            if each.yourName == user {
                if each.yourScore > each.friendScore {
                    pointsWin += 1
                } else if each.yourScore == each.friendScore {
                    pointsDraw += 1
                } else if each.yourScore < each.friendScore {
                    pointsLose += 1
                }
            }
            
            if each.friendName == user {
                if each.friendScore > each.yourScore {
                    pointsWin += 1
                } else if each.friendScore == each.yourScore {
                    pointsDraw += 1
                } else if each.friendScore < each.yourScore {
                    pointsLose += 1
                }
            }
        }

    }
    
    func addPointsToLabels() {
        winScoreLabel.text = String(pointsWin)
        drawScoreLabel.text = String(pointsDraw)
        loseScoreLabel.text = String(pointsLose)
        
        pointsTotal = pointsLose + pointsDraw + pointsWin
        totalScoreLabel.text = String(pointsTotal)
    }
    
    func addPercentToLabels() {
        if pointsWin != 0 || pointsTotal != 0 {
            percentWin = Double(pointsWin / pointsTotal)
        }
        
        if pointsDraw != 0 || pointsTotal != 0 {
            percentDraw = Double(pointsDraw / pointsTotal)

        }
        
        if pointsLose != 0 || pointsTotal != 0 {
            percentLose = Double(pointsLose / pointsTotal)

        }
        
        winPercentLabel.text = String(percentWin) + " %"
        drawPercentLabel.text = String(percentDraw) + " %"
        losePercentLabel.text = String(percentLose) + " %"
    }
    
    
    
    
}
