//
//  OnboardingVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-04-18.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit


class OnboardingVC: UIViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setViewLayout(view: self.view)
        addButtonLayout()
        
    }
    
    
    // Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var userBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userTopConstraint: NSLayoutConstraint!

    
    // Actions
    @IBAction func actionButton(_ sender: UIButton) {
        
        if let text = textField.text {
            UserDefaults.standard.set(text, forKey: forKey.Username.rawValue)
            //FIXME: Add image as well
            if let user = StoredUserData(username: text, image: #imageLiteral(resourceName: "DefaultImage"), id: 0) {
                addUserData.append(user)
            }
        }

        performSegue(withIdentifier: identifiersSegue.OnboardingVCSegueToMain.rawValue, sender: self)
        
        
    }
    
    @IBAction func skipActionButton(_ sender: UIButton) {
        
        var counterTop = userTopConstraint.constant
        var counterBottom = userBottomConstraint.constant
        
        
        while counterTop > 0 {
            counterTop -= 1
            userTopConstraint.constant = counterTop
            counterBottom += 1
            userBottomConstraint.constant = counterBottom
            animateWithDuration(time: 0.1)
        }
        
        
        performSegue(withIdentifier: identifiersSegue.OnboardingVCSegueToMain.rawValue, sender: self)
        print("Segue")
    }
    
    // Functions
    func animateWithDuration(time: Double) {
        // Animate with duration
        UIView.animate(withDuration: time) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addButtonLayout() {
        onboardingButtonLayout(button: button)
        onboardingButtonLayout(button: skipButton)
    }
    
    
}
