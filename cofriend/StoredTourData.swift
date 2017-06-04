//
//  StoredTourData.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log


var tournaments = [TournamentClass]()

class TournamentClass: NSObject {
    var id: String?
    var createdByUserId: String?
    var name: String?
    //var players: [UserClass]?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.createdByUserId = dictionary["createdByUserId"] as? String
        self.name = dictionary["name"] as? String
        //self.players = dictionary["players"] as? [UserClass]
    }
}

var players = [PlayerClass]()

class PlayerClass: NSObject {
    var tournamentId: String?
    var players: [UserClass]?
    
    init(tournamentId: String?, players: [UserClass]?) {
        self.tournamentId = tournamentId
        self.players = players
    }
}

enum stringsInTournamentClass: String {
    case id
    case name
    case createdByUserId
    case players = "Players"
}


/*
class StoredTourData: NSObject, NSCoding {
    
    // MARK: Properties
    
    var tournamentTitle: String
    var players: [StoredUserData]
    var pointsWin: Int
    var pointsDraw: Int
    var pointsLose: Int
    var id: Int
    
    
    // MARK: Archiving Paths
    
    /* Static keyword, apply to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.*/
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // FIXME: No catch argument
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("storedTourData")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let tournamentTitleKey = "tournamentTitle"
        static let playersKey = "players"
        static let pointsWinKey = "pointsWin"
        static let pointsDrawKey = "pointsDraw"
        static let pointsLoseKey = "pointsLose"
        static let idKey = "id"
    }
    
    
    // MARK: Initialization
    
    init?(tournamentTitle: String, players: [StoredUserData], pointsWin: Int, pointsDraw: Int, pointsLose: Int, id: Int) {
        // Initialize stored properties.
        self.tournamentTitle = tournamentTitle
        self.players = players
        self.pointsWin = pointsWin
        self.pointsDraw = pointsDraw
        self.pointsLose = pointsLose
        self.id = id
        
        //add a call to the superclass’s initializer.
        super.init()
        
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tournamentTitle, forKey: PropertyKey.tournamentTitleKey)
        aCoder.encode(players, forKey: PropertyKey.playersKey)
        aCoder.encode(pointsWin, forKey: PropertyKey.pointsWinKey)
        aCoder.encode(pointsDraw, forKey: PropertyKey.pointsDrawKey)
        aCoder.encode(pointsLose, forKey: PropertyKey.pointsLoseKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let tournamentTitle = aDecoder.decodeObject(forKey: PropertyKey.tournamentTitleKey) as! String
        let players = aDecoder.decodeObject(forKey: PropertyKey.playersKey) as! [StoredUserData]
        
        let pointsWin = aDecoder.decodeInteger(forKey: PropertyKey.pointsWinKey)
        let pointsDraw = aDecoder.decodeInteger(forKey: PropertyKey.pointsDrawKey)
        let pointsLose = aDecoder.decodeInteger(forKey: PropertyKey.pointsLoseKey)

        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.idKey)
        
        
        // Must call designated initilizer.
        self.init(tournamentTitle: tournamentTitle, players: players, pointsWin: pointsWin, pointsDraw: pointsDraw, pointsLose: pointsLose, id: id)
    }
    
}

// MARK: Global

// Global variables
var addTourData = [StoredTourData]()

// Global functions
func loadTourData() -> [StoredTourData]?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: StoredTourData.ArchiveURL.path) as? [StoredTourData]
}

/*
 You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
 Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
 */

func saveTourData() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addTourData, toFile: StoredTourData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save...", log: OSLog.default, type: .error)
    }
}
*/



