//
//  StoredPoints.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-07-12.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import os.log


var points = [PointClass]()
var dictPoints: [String:String] = [:]

class PointClass: NSObject {
    var id: String?
    var gameId: String?
    var nameId: String?
    var win: String? = "0"
    var draw: String? = "0"
    var lose: String? = "0"  
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.gameId = dictionary["gameId"] as? String
        self.nameId = dictionary["nameId"] as? String
        self.win = dictionary["win"] as? String
        self.draw = dictionary["draw"] as? String
        self.lose = dictionary["lose"] as? String    }
}
