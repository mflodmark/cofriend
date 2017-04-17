//
//  ScoreDataModel.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

typealias Point = Int
typealias Percent = Int

// MARK: Enums
enum ScoreTypes: Int {
    case Win
    case Lose
    case Draw
    case Total
}


// Users should be able to decide of much a win/draw/loose is worth in points
extension ScoreTypes {
    var points: Point {
        switch self {
        case .Win: return self.points + 3
        case .Lose: return self.points + 0
        case .Draw: return self.points + 1
        case .Total: return self.points
        }
    }
    
    var games: Int {
        switch self {
        case .Draw, .Lose, .Win: return self.games + 1
        case .Total: return self.games
        }
    }
}

enum ScoreTypesPercent: Percent {
    case Win
    case Lose
    case Draw
}

extension ScoreTypesPercent {
    var totalPercent: Percent {
        switch self {
        case .Win: return (ScoreTypes.Win.games / ScoreTypes.Total.games)
        case .Lose: return (ScoreTypes.Lose.games / ScoreTypes.Total.games)
        case .Draw: return (ScoreTypes.Draw.games / ScoreTypes.Total.games)
        }
    }
}


enum Titles: String {
    case Done
    case Title = "Game Title"
    case YourImage = "Your Image"
    case FriendImage = "Friend Image"
    case DatePicker = "Pick Date"
    case YourScore = "Your Score"
    case FriendScore = "Friend score"
    case Add
    case YourUserId = "Your UserId"
    case FriendUserId = "Friend UserId"
    case Exit
    case Delete
}

enum GameTitles: String {
    case FIFA
    case NHL
    case Badminton
    case Squash
    case Tennis
}

enum Images: String {
    case Default = "DefaultImage.jpg"
}



// MARK: Arrays
var scoreTitleArray = [
    GameTitles.Badminton.rawValue,
    GameTitles.FIFA.rawValue,
    GameTitles.NHL.rawValue,
    GameTitles.Squash.rawValue,
    GameTitles.Tennis.rawValue
]

var defaultPlayer = Player(userName: "Riverland", userImage: UIImage(named: Images.Default.rawValue)!)
var defaultPlayerAgain = Player(userName: "mFlodmark", userImage: UIImage(named: Images.Default.rawValue)!)

var playerArray = [defaultPlayer, defaultPlayerAgain]

var addStoredData = [StoredScoreData]()
var pagesWithStoredDataArray = [[StoredScoreData]]()

var intForDateArray = Int()
