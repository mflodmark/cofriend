//
//  ScoreInsideTourVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class ScoreInsideTourVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // MARK: Declarations
    let teamOneDefault = StoredUserData(username: "No Data", image: #imageLiteral(resourceName: "DefaultImage"), id: 0)
    let teamTwoDefault = StoredUserData(username: "No Data", image: #imageLiteral(resourceName: "DefaultImage"), id: 0)

    var tournament = StoredTournamentData(tournamentTitle: "No Data", gameTitle: "", teamOnePlayers: [], teamTwoPlayers: [], teamOneScore: 0, teamTwoScore: 0, image: #imageLiteral(resourceName: "DefaultImage"), date: "No Data", id: 0)

    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var pointsA: UILabel!
    @IBOutlet weak var pointsB: UILabel!
    @IBOutlet weak var addPointsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamA: UILabel!
    @IBOutlet weak var teamB: UILabel!
    
    // MARK: Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        prepareSavingData()
        saveTournamentData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateActionButton(_ sender: UIButton) {
    }
    
    @IBAction func addPointsActionButton(_ sender: UIButton) {
    }
    
    
    
    // MARK: Functions
    // cast pointA & B
    func prepareSavingData() {
        if let tournament = selectedTour?.tournamentTitle, let game = selectedGame?.scoreTitle, let date = dateButton.title(for: .normal) {
            let game = StoredTournamentData(tournamentTitle: tournament, gameTitle: game, teamOnePlayers: <#T##[StoredUserData]#>, teamTwoPlayers: <#T##[StoredUserData]#>, teamOneScore: pointsA, teamTwoScore: pointsB, image: nil, date: date, id: idForTournamentData)
            addTournamentData.append(game!)
            
            idForTournamentData += 1
            // Save id
            UserDefaults.standard.set(String(idForTournamentData), forKey: forKey.TournamentDataId.rawValue)
        }
    }
    
    
    
    
    
}
