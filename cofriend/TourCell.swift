//
//  AddTourCell.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class TournamentCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initalixation code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected,animated: animated)
        
        //configure the view for selected state
    }
    
    // MARK: Properties
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var countingPlayer: UILabel!
    
    
}
