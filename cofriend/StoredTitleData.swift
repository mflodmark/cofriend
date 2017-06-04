//
//  StoredData.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-19.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log


var games = [GameClass]()

class GameClass: NSObject {
    var id: String?
    var tournamentId: String?
    var createdByUserId: String?
    var name: String?
    var winPoints: String?
    var drawPoints: String?
    var losePoints: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.tournamentId = dictionary["tournamentId"] as? String
        self.createdByUserId = dictionary["createdByUserId"] as? String
        self.name = dictionary["name"] as? String
        self.winPoints = dictionary["winPoints"] as? String
        self.drawPoints = dictionary["drawPoints"] as? String
        self.losePoints = dictionary["losePoints"] as? String

    }
}


/*
class StoredTitleData: NSObject, NSCoding {
    
    // MARK: Properties
    
    var scoreTitle: String
    var id: Int
    
    // MARK: Archiving Paths
    
    /* Static keyword, apply to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.*/
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // FIXME: No catch argument
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("storedTitleData")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let scoreTitleKey = "scoreTitle"
        static let idKey = "id"
     
    }
    
    
    // MARK: Initialization
    
    init?(scoreTitle: String, id: Int) {
        // Initialize stored properties.
        self.scoreTitle = scoreTitle
        self.id = id
        
        //add a call to the superclass’s initializer.
        super.init()
        
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(scoreTitle, forKey: PropertyKey.scoreTitleKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.idKey)
        let scoreTitle = aDecoder.decodeObject(forKey: PropertyKey.scoreTitleKey) as! String
        
        // Must call designated initilizer.
        self.init(scoreTitle: scoreTitle, id: id)
    }
    /*
     You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
     */
}

// MARK: Global

// Global variabels
var addScoreTitle = [StoredTitleData]()


// Global functions

func saveScoreTitleData() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addScoreTitle, toFile: StoredTitleData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save...", log: OSLog.default, type: .error)
    }
}

func loadScoreTitleData() -> [StoredTitleData]?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: StoredTitleData.ArchiveURL.path) as? [StoredTitleData]
}*/
