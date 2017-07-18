//
//  DetailsCell.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-07-07.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//


import Foundation
import UIKit

class DetailsCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initalixation code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected,animated: animated)
        
        //configure the view for selected state
    }
    
    // MARK: Properties
    
    @IBOutlet weak var nr: UILabel!
  
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var win: UILabel!
    @IBOutlet weak var draw: UILabel!
    
    @IBOutlet weak var lose: UILabel!
    @IBOutlet weak var points: UILabel!
}
