//
//  PlayerDataModel.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class Player {
        
    var userName: String
    var userImage: UIImage
    //var userScoreTotal: ScoreTypes
    //var userPercentTotal: ScoreTypesPercent
    
    
    init(userName: String, userImage: UIImage) {
        self.userName = userName
        self.userImage = userImage
        //self.userScoreTotal = userScoreTotal
        //self.userPercentTotal = userPercentTotal
    }

 
}

