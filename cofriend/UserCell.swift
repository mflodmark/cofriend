//
//  UserCell.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-23.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myImage.translatesAutoresizingMaskIntoConstraints = false
        myImage.layer.cornerRadius = 24
        myImage.layer.masksToBounds = true
        myImage.contentMode = .scaleAspectFill
    }
}


