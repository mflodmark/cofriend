//
//  StoredGameTitleData.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log

class StoredGameTitleData: NSObject, NSCoding {
    
    // MARK: Properties
    
    var tournamentTitle: String
    var scoreTitle: String
    var id: Int
    
    // MARK: Archiving Paths
    
    /* Static keyword, apply to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.*/
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // FIXME: No catch argument
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("storedGameTitleData")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let tournamentTitle = "tournamentTitle"
        static let scoreTitleKey = "scoreTitle"
        static let idKey = "id"
        
    }
    
    
    // MARK: Initialization
    
    init?(tournamentTitle: String, scoreTitle: String, id: Int) {
        // Initialize stored properties.
        self.tournamentTitle = tournamentTitle
        self.scoreTitle = scoreTitle
        self.id = id
        
        //add a call to the superclass’s initializer.
        super.init()
        
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tournamentTitle, forKey: PropertyKey.tournamentTitle)
        aCoder.encode(scoreTitle, forKey: PropertyKey.scoreTitleKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.idKey)
        let scoreTitle = aDecoder.decodeObject(forKey: PropertyKey.scoreTitleKey) as! String
        let tournamentTitle = aDecoder.decodeObject(forKey: PropertyKey.tournamentTitle) as! String
        
        // Must call designated initilizer.
        self.init(tournamentTitle: tournamentTitle, scoreTitle: scoreTitle, id: id)
    }
    /*
     You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
     */
}

// MARK: Global

// Global variabels
var addGameTitle = [StoredGameTitleData]()


// Global functions

func saveGameTitleData() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addGameTitle, toFile: StoredGameTitleData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save...", log: OSLog.default, type: .error)
    }
}

func loadGameTitleData() -> [StoredGameTitleData]?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: StoredGameTitleData.ArchiveURL.path) as? [StoredGameTitleData]
}
