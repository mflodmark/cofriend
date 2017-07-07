//
//  AddGoalscorersVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-06-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class AddGoalscorersVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewLayout(view: self.view)

        getPoints()
        //hideButtons()
        getNames()
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var goalsTeamB: UILabel!
    @IBOutlet weak var goalsTeamA: UILabel!
    @IBOutlet weak var teamAOne: UIButton!
    
    @IBOutlet weak var teamATwo: UIButton!
    
    @IBOutlet weak var teamBOne: UIButton!
    @IBOutlet weak var teamBTwo: UIButton!
    
    let scoreInsideTour = ScoreInsideTourVC()
    var goalA: Int = 0
    var goalB: Int = 0

    
    // MARK: Actions
    
    
    @IBAction func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func teamAction(_ sender: UIButton) {
        
        switch sender {
        case teamAOne:
            if goalA != 0 {
                goalA -= 1
                teamAOneGoals += 1
            }
        case teamATwo:
            if goalA != 0 {
                goalA -= 1
                teamATwoGoals += 1
            }
        case teamBOne:
            if goalB != 0 {
                goalB -= 1
                teamBOneGoals += 1
            }
        case teamBTwo:
            if goalB != 0 {
                goalB -= 1
                teamBTwoGoals += 1
            }
        default: print("Default button")
        }

        setNewPoints()
        getNames()
    }
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        getPoints()
        getNames()
    }
    
    // MARK: Functions
    
    func getPoints() {
        
        goalsTeamA.text = preSelectedScore.teamAPoints
        goalsTeamB.text = preSelectedScore.teamBPoints
        goalA = Int(preSelectedScore.teamAPoints!)!
        goalB = Int(preSelectedScore.teamBPoints!)!
        teamAOneGoals = 0
        teamATwoGoals = 0
        teamBOneGoals = 0
        teamBTwoGoals = 0

    }
    
    func setNewPoints() {
        goalsTeamA.text = String(goalA)
        goalsTeamB.text = String(goalB)
    }
    
    func hideButtons() {
        teamAOne.isHidden = true
        teamATwo.isHidden = true
        teamBOne.isHidden = true
        teamBTwo.isHidden = true

    }
    
    func getNames() {
        // Names for A
        if teamOneArray.count == 1 {
            teamAOne.setTitle("\(teamOneArray[0].name!): \(teamAOneGoals)", for: .normal)
            teamAOne.isHidden = false
        } else if teamOneArray.count == 2 {
            teamAOne.setTitle("\(teamOneArray[0].name!): \(teamAOneGoals)", for: .normal)
            teamATwo.setTitle("\(teamOneArray[1].name!): \(teamATwoGoals)", for: .normal)
            teamAOne.isHidden = false
            teamATwo.isHidden = false

        }
        
        // Names for B
        if teamTwoArray.count == 1 {
            teamBOne.setTitle("\(teamTwoArray[0].name!): \(teamBOneGoals)", for: .normal)
            teamBOne.isHidden = false
        }
        else if teamTwoArray.count == 2 {
            teamBOne.setTitle("\(teamTwoArray[0].name!): \(teamBOneGoals)", for: .normal)
            teamBTwo.setTitle("\(teamTwoArray[1].name!): \(teamBTwoGoals)", for: .normal)
            teamBOne.isHidden = false
            teamBTwo.isHidden = false
        }
    }
}
