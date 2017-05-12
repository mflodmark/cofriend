//
//  StoredData.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-16.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log

class StoredScoreData: NSObject, NSCoding {
    
    // MARK: Properties
    
    var scoreTitle: String
    var yourImage: UIImage
    var yourName: String
    var friendImage: UIImage
    var friendName: String
    var yourScore: Point
    var friendScore: Point
    var date: String
    var id: Int
    
    // MARK: Archiving Paths
    
    /* Static keyword, apply to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.*/

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // FIXME: No catch argument
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("storedScoreData")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let scoreTitleKey = "scoreTitle"
        static let yourScoreKey = "yourScore"
        static let friendScoreKey = "friendScore"
        static let yourImageKey = "yourImage"
        static let friendImageKey = "friendImage"
        static let yourNameKey = "yourName"
        static let friendNameKey = "friendName"
        static let dateKey = "date"
        static let idKey = "id"
    }
    
    
    // MARK: Initialization
    
    init?(scoreTitle: String, yourScore: Int, friendScore: Int, yourImage: UIImage, friendImage: UIImage, date: String, yourName: String, friendName: String, id: Int) {
        // Initialize stored properties.
        self.scoreTitle = scoreTitle
        self.yourScore = yourScore
        self.friendScore = friendScore
        self.yourImage = yourImage
        self.friendImage = friendImage
        self.date = date
        self.yourName = yourName
        self.friendName =  friendName
        self.id = id
        
        //add a call to the superclass’s initializer.
        super.init()
        
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(scoreTitle, forKey: PropertyKey.scoreTitleKey)
        aCoder.encode(yourScore, forKey: PropertyKey.yourScoreKey)
        aCoder.encode(friendScore, forKey: PropertyKey.friendScoreKey)
        aCoder.encode(yourImage, forKey: PropertyKey.yourImageKey)
        aCoder.encode(friendImage, forKey: PropertyKey.friendImageKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
        aCoder.encode(friendName, forKey: PropertyKey.friendNameKey)
        aCoder.encode(yourName, forKey: PropertyKey.yourNameKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let scoreTitle = aDecoder.decodeObject(forKey: PropertyKey.scoreTitleKey) as! String
        
        let yourScore = aDecoder.decodeInteger(forKey: PropertyKey.yourScoreKey)
        let friendScore = aDecoder.decodeInteger(forKey: PropertyKey.friendScoreKey)
        let id = aDecoder.decodeInteger(forKey: PropertyKey.idKey)
        
        let yourImage = aDecoder.decodeObject(forKey: PropertyKey.yourImageKey) as! UIImage
        let friendImage = aDecoder.decodeObject(forKey: PropertyKey.friendImageKey) as! UIImage
        
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as! String
        
        let friendName = aDecoder.decodeObject(forKey: PropertyKey.friendNameKey) as! String
        let yourName = aDecoder.decodeObject(forKey: PropertyKey.yourNameKey) as! String
        
        
        
        // Must call designated initilizer.
        self.init(scoreTitle: scoreTitle, yourScore: yourScore, friendScore: friendScore, yourImage: yourImage, friendImage: friendImage, date: date, yourName: yourName, friendName: friendName, id: id)
    }
    
}

// MARK: Global

// Global variables
var addStoredData = [StoredScoreData]()

// Global functions
func loadData() -> [StoredScoreData]?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: StoredScoreData.ArchiveURL.path) as? [StoredScoreData]
}

/*
 You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
 Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
 */

func saveData() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addStoredData, toFile: StoredScoreData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save...", log: OSLog.default, type: .error)
    }
}




