//
//  ViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-24.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setViewLayout(view: self.view)
        setupButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func buttonLayout(senderButton: UIButton, nameOfButton: String, backgroundImage: String) {
        // Size of button
        senderButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        
        // SIze of title, title color & title name
        senderButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        senderButton.setTitleColor(UIColor.white, for: UIControlState())
        senderButton.setTitle(nameOfButton, for: UIControlState())
        
        senderButton.setBackgroundImage(UIImage(named: backgroundImage), for: UIControlState())

        view.layoutIfNeeded()
        
        view.addSubview(senderButton)

    }
    
    var button1: UIButton!
    var topButtonConstraint: NSLayoutConstraint!
    
    func setupButton() {
        
        button1 = UIButton(type: UIButtonType.system) // .System
        
        // 20 point status bar, 8 point margins
        button1.center = CGPoint(x: view.bounds.width / 2, y: 20 + 40 + 8)
        
        // Adding target when pressing the button
        button1.addTarget(self, action: #selector(addNewButton(_:)), for: UIControlEvents.touchUpInside)
        
        buttonLayout(senderButton: button1, nameOfButton: "New button", backgroundImage: "BlueButton")
        
        
        // Auto Layout rules
        
        /*
        // Disable Auto Resizing constraints
        button1.translatesAutoresizingMaskIntoConstraints = false
        
        // left edge
        let leftButtonEdgeConstraint = NSLayoutConstraint(item: button1, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 0)
        // right edge
        let rightButtonEdgeConstraint = NSLayoutConstraint(item: button1, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: 0)
        
        // bottom
        topButtonConstraint = NSLayoutConstraint(item: button1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: 20)
        
        // add all constraints
        view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, topButtonConstraint])
        */
    }

    var newButton: UIButton!
    var size: CGFloat!


    func addNewButton(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 15, options: [], animations: { () -> Void in
        
        self.newButton = UIButton(type: UIButtonType.system) // .System
        
        // 80 point button, 20 point status bar, 40 point half button, 8 point margins
        self.size = CGFloat(20 + 40 + 8 + 80 + 8)
        self.newButton.center = CGPoint(x: self.view.bounds.width / 2, y: self.size)
        
        // Adding target when pressing the button
        //newButton.addTarget(self, action: #selector(addNewButton(_:)), for: UIControlEvents.touchUpInside)
        
        //self.topButtonConstraint.constant = 100
            
        self.buttonLayout(senderButton: self.newButton, nameOfButton: "Badminton", backgroundImage: "BlueButton")
        })
    }
    
    
    // segue
    /*
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
    
    let storyboard = UIStoryboard.Storyboard(.main)
    let viewController: ScoreViewController = storyboard.instantiateViewController()
    presentViewController(viewController, animated: true, completion: nil)
    */
    
}



