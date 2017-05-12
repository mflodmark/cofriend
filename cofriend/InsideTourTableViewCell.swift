//
//  InsideTourTableViewCell.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class InsideTourTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initalixation code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected,animated: animated)
        
        //configure the view for selected state
    }
    
    // MARK: Properties
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var playerOne: UILabel!
    @IBOutlet weak var playerTwo: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    @IBOutlet weak var vs: UILabel!
    @IBOutlet weak var friendScore: UILabel!
    @IBOutlet weak var friendOne: UILabel!
    @IBOutlet weak var friendTwo: UILabel!
    
    
}
