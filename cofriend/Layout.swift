//
//  Layout.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

func setViewLayout(view: UIView) {
    view.backgroundColor? = UIColor.lightGray
}

func setDefaultButtonLayout(button: UIButton) {
    button.alpha = 1.0
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    button.layer.cornerRadius = 5
}

func setRoundButtonLayout(button: UIButton) {
    button.layer.cornerRadius = 0.5 * button.bounds.size.width
    button.clipsToBounds = true
}

func setButtonLayout(eachButton: UIButton) {
    eachButton.setTitleColor(UIColor.orange, for: .normal)
    eachButton.backgroundColor = UIColor.darkGray
    setDefaultButtonLayout(button: eachButton)
}


func setDoneButtonLayout(button: UIButton) {
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor.green
    setDefaultButtonLayout(button: button)
}

func setExitButtonLayout(button: UIButton) {
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor.red
    setDefaultButtonLayout(button: button)
}

func setTextFieldButtonLayout(button: UIButton) {
    button.setTitleColor(UIColor.white, for: .normal)
    //button.backgroundColor = UIColor.green
    button.setBackgroundImage(#imageLiteral(resourceName: "GreenButton"), for: .normal)
    setDefaultButtonLayout(button: button)
    //setRoundButtonLayout(button: button)
}