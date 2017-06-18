//
//  UserStoredData.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-18.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log


var users = [UserClass]()


class UserClass: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var win: String? = "0"
    var draw: String? = "0"
    var lose: String? = "0"
    //var tournaments: [TournamentClass]?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.win = dictionary["win"] as? String
        self.draw = dictionary["draw"] as? String
        self.lose = dictionary["lose"] as? String
        //self.tournaments = dictionary["tournaments"] as? TournamentClass
    }
}

var gameUsers = [gameUserClass]()

class gameUserClass: NSObject {
    var gamePoints: Int
    var userId: String
    
    init(gamePoints: Int, userId: String) {
        self.gamePoints = gamePoints
        self.userId = userId
    }
}


class StoredUserData: NSObject, NSCoding {
    
    // MARK: Properties
    
    //var score: ScoreTypes
    var username: String
    var image: UIImage
    var id: Int
    
    
    // MARK: Archiving Paths
    
    /* Static keyword, apply to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path!.*/
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // FIXME: No catch argument
    static let ArchiveURL = try! DocumentsDirectory.appendingPathComponent("storedUserData")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let usernameKey = "username"
        static let idKey = "id"
        static let imageKey = "image"
    }
    
    
    // MARK: Initialization
    
    init?(username: String, image: UIImage, id: Int) {
        // Initialize stored properties.
        self.username = username
        self.image = image
        self.id = id
        
        //add a call to the superclass’s initializer.
        super.init()
        
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.usernameKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(image, forKey: PropertyKey.imageKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.idKey)
        let username = aDecoder.decodeObject(forKey: PropertyKey.usernameKey) as! String
        let image = aDecoder.decodeObject(forKey: PropertyKey.imageKey) as! UIImage
        
        // Must call designated initilizer.
        self.init(username: username, image: image, id: id)
    }
    /*
     You mark these constants with the static keyword, which means they belong to the class instead of an instance of the class.
     Outside of the Meal class, you’ll access the path using the syntax Meal.ArchiveURL.path. There will only ever be one copy of these properties, no matter how many instances of the Meal class you create.
     */
}

// MARK: Global

// Global variabels
var addUserData = [StoredUserData]()


// Global functions

func saveUserData() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(addUserData, toFile: StoredUserData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save...", log: OSLog.default, type: .error)
    }
}

func loadUserData() -> [StoredUserData]?  {
    return NSKeyedUnarchiver.unarchiveObject(withFile: StoredUserData.ArchiveURL.path) as? [StoredUserData]
}
