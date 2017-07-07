//
//  Identifiers.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-18.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

let uid = Auth.auth().currentUser?.uid
var selectedTour = TournamentClass(dictionary: ["" : "" as AnyObject])
var selectedPlayer = PlayerClass(tournamentId: "", players: [])
var selectedGame = GameClass(dictionary: ["" : "" as AnyObject])
var selectedScore = ScoreClass(dictionary: ["": "" as AnyObject])
var selectedScorePlayer = ScorePlayerClass(gameId: nil, scoreId: nil, players: [])
var selectedTourCell: Bool = false
var selectedGameCell: Bool = false
var selectedScoreCell: Bool = false
var preSelectedScore = ScoreClass(dictionary: ["": "" as AnyObject])
var friendRequest: [UserClass] = [UserClass]()


enum forKey: String {
    case Username
    case UsernameDataId
    case GameTitleDataId
    case ScoreDataId
    case TourDataId
    case GameTitleId
    case TournamentDataId
}

enum defaultGames: String {
    case tennis = "Tennis"
    case tableTennis = "Table Tennis"
    case fifa = "FIFA"
    case nhl = "NHL"
    case squash = "Squash"
    case badminton = "Badminton"
}

/*
enum identifiersVC: String {
    case OnboardingVC
}*/

enum identifiersSegue: String {
    case OnboardingVCSegueToMain
    case EditToAddScore
    case AddToAddScore
    case AddToAddTournamentScore
    case CellToAddTournamentScore
    case CellToGame
    case CellToInputs
    case AddGame
    case AddScore
    case AddGoalscorers
}

enum identifiersCell: String {
    case InsideTourTableViewCell
    case AddTourCell
    case TournamentCell
    case AddGamesCell
    case ScoreInsideCell
    case ScoreCollCell
    case PlayerCell
    case TableCollCell
    case AddPlayerCell
    case CellToDetails
}

enum identifiersStoryboard: String {
    case Main
    case Data
    case Score
    case DatePicker
    case Onboarding
}

enum identifiersArchiveUrl: String {
    case storedScoreData
    case storedUserData
}
/*
// Counter for data id
var id = Int()
var idForUserData = Int()
var idForTitleData = Int()
var idForTourData = Int()
var idForGameTitle = Int()
var idForTournamentData = Int()


func getIdForSavedData() {
    // Score data id
    let getScoreDataId = UserDefaults.standard.value(forKey: String(forKey.ScoreDataId.rawValue)) as? String
    if getScoreDataId == nil {
        // Init of Id counter
        id = 0
    } else {
        id = Int(getScoreDataId!)!
    }
    
    // Username data id
    let getUsernameDataId = UserDefaults.standard.value(forKey: String(forKey.UsernameDataId.rawValue)) as? String
    if getUsernameDataId == nil {
        // Init of Id counter, starting with 1 since the user should be 0 when they have added a username
        idForUserData = 1
    } else {
        idForUserData = Int(getUsernameDataId!)!
    }
    
    // Title data id
    let getTitleDataId = UserDefaults.standard.value(forKey: String(forKey.GameTitleDataId.rawValue)) as? String
    if getTitleDataId == nil {
        // Init of Id counter
        idForTitleData = 0
    } else {
        idForTitleData = Int(getTitleDataId!)!
    }
    
    // Tour data id
    let getTourDataId = UserDefaults.standard.value(forKey: String(forKey.TourDataId.rawValue)) as? String
    if getTourDataId == nil {
        // Init of Id counter
        idForTourData = 0
    } else {
        idForTourData = Int(getTourDataId!)!
    }
    
    // Tour data id
    let getGameTitleId = UserDefaults.standard.value(forKey: String(forKey.GameTitleId.rawValue)) as? String
    if getGameTitleId == nil {
        // Init of Id counter
        idForGameTitle = 0
    } else {
        idForGameTitle = Int(getGameTitleId!)!
    }
    
    // Tournament data id
    let getTournamentDataId = UserDefaults.standard.value(forKey: String(forKey.TournamentDataId.rawValue)) as? String
    if getTournamentDataId == nil {
        // Init of Id counter
        idForTournamentData = 0
    } else {
        idForTournamentData = Int(getTourDataId!)!
    }
    
    
}
 */

