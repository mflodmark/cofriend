//
//  StoredTournamentData.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log

var scores = [ScoreClass]()

class ScoreClass: NSObject {
    var id: String?
    //var tournamentId: String?
    var gameId: String?
    var createdByUserId: String?
    var name: String?
    var date: String?
    var teamAPoints: String?
    var teamBPoints: String?
    var overtime: Bool?
    var penalties: Bool?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        //self.tournamentId = dictionary["tournamentId"] as? String
        self.gameId = dictionary["gameId"] as? String
        self.createdByUserId = dictionary["createdByUserId"] as? String
        self.name = dictionary["name"] as? String
        self.date = dictionary["date"] as? String
        self.teamAPoints = dictionary["teamAPoints"] as? String
        self.teamBPoints = dictionary["teamBPoints"] as? String
    }
}

var teamAArray = [ScorePlayerClass]()
var teamBArray = [ScorePlayerClass]()
var teamAOneGoals: Int = 0
var teamATwoGoals: Int = 0
var teamBOneGoals: Int = 0
var teamBTwoGoals: Int = 0


class ScorePlayerClass: NSObject {
    var gameId: String?
    var scoreId: String?
    var players: [UserClass]?
    var goalscorers: [UserClass:String]?
    
    init(gameId: String?, scoreId: String?, players: [UserClass]?) {
        self.gameId = gameId
        self.scoreId = scoreId
        self.players = players
    }
}




/*
class StoredTournamentData: NSObject, NSCoding {
    
    // MARK: Properties
    
    var tournamentTitle: String
    var gameTitle: String
    var teamOnePlayers: [StoredUserData]
    var teamTwoPlayers: [StoredUserData]
    var teamOneScore: Int
    var teamTwoScore: Int
    var image: UIImage
    var date: String
    var id: Int

    
    // MARK: Archiving Paths
    
    /* Static keyword, apply to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.*/
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // FIXME: No catch argument
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("storedTournamentData")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let tournamentTitleKey = "tournamentTitle"
        static let gameTitle = "gameTitle"
        static let teamOnePlayersKey = "teamOnePlayers"
        static let teamTwoPlayersKey = "teamTwoPlayers"
        static let teamOneScoreKey = "teamOneScore"
        static let teamTwoScoreKey = "teamTwoScore"
        static let imageKey     = "image"
        static let dateKey = "date"
        static let idKey = "id"
    }
    
    
    // MARK: Initialization
    
    init?(tournamentTitle: String, gameTitle: String, teamOnePlayers: [StoredUserData], teamTwoPlayers: [StoredUserData], teamOneScore: Int, teamTwoScore: Int, image: UIImage, date: String, id: Int) {
        // Initialize stored properties.
        self.tournamentTitle = tournamentTitle
        self.gameTitle = gameTitle
        self.teamOnePlayers = teamOnePlayers
        self.teamTwoPlayers = teamTwoPlayers
        self.teamOneScore = teamOneScore
        self.teamTwoScore = teamTwoScore
        self.image = image
        self.date = date
        self.id = id
        
        //add a call to the superclass’s initializer.
        super.init()
        
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tournamentTitle, forKey: PropertyKey.tournamentTitleKey)
        aCoder.encode(gameTitle, forKey: PropertyKey.gameTitle)
        aCoder.encode(teamOnePlayers, forKey: PropertyKey.teamOnePlayersKey)
        aCoder.encode(teamTwoPlayers, forKey: PropertyKey.teamTwoPlayersKey)
        aCoder.encode(teamTwoScore, forKey: PropertyKey.teamTwoScoreKey)
        aCoder.encode(teamOneScore, forKey: PropertyKey.teamOneScoreKey)
        aCoder.encode(image, forKey: PropertyKey.imageKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let tournamentTitle = aDecoder.decodeObject(forKey: PropertyKey.tournamentTitleKey) as! String
        
        let gameTitle = aDecoder.decodeObject(forKey: PropertyKey.gameTitle) as! String
        let teamOnePlayers = aDecoder.decodeObject(forKey: PropertyKey.teamOnePlayersKey) as! [StoredUserData]
        let teamTwoPlayers = aDecoder.decodeObject(forKey: PropertyKey.teamTwoPlayersKey) as! [StoredUserData]

        let image = aDecoder.decodeObject(forKey: PropertyKey.imageKey) as! UIImage

        let teamOneScore = aDecoder.decodeInteger(forKey: PropertyKey.teamOneScoreKey)
        let teamTwoScore = aDecoder.decodeInteger(forKey: PropertyKey.teamTwoScoreKey)
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.idKey)
        
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as! String
        
        
        
        
        // Must call designated initilizer.
        self.init(tournamentTitle: tournamentTitle, gameTitle: gameTitle, teamOnePlayers: teamOnePlayers, teamTwoPlayers: teamTwoPlayers, teamOneScore: teamOneScore, teamTwoScore: teamTwoScore, image: image, date: date, id: id)
    }
    
}

// MARK: Global

// Global variables
var addTournamentData = [StoredTournamentData]()

// Global functions
func loadTournamentData() -> [StoredTournamentData]?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: StoredTournamentData.ArchiveURL.path) as? [StoredTournamentData]
}

/*
 You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
 Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
 */

func saveTournamentData() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addTournamentData, toFile: StoredTournamentData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save...", log: OSLog.default, type: .error)
    }
}*/




