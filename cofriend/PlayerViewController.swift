//
//  PlayerViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class PlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewLayout(view: self.view)

        //getPlayer()
        addPointsToLabels()
        addPercentToLabels()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    
    // MARK: Declarations
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIButton!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winScoreLabel: UILabel!
    @IBOutlet weak var winPercentLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var drawScoreLabel: UILabel!
    @IBOutlet weak var drawPercentLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var loseScoreLabel: UILabel!
    @IBOutlet weak var losePercentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    let user = (UserDefaults.standard.value(forKey: forKey.Username.rawValue) as? String)
    var pointsWin = 0
    var pointsDraw = 0
    var pointsLose = 0
    var pointsTotal = Int()
    var percentWin = 0.00
    var percentDraw = 0.00
    var percentLose = 0.00
    
    // MARK: Actions
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
    }
    
    // MARK: Functions
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            print("User is not logged in")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            print("User is logged in")
            
            fetchUser()
        }
    }
    
    func fetchUser() {
        // Current user id
        let uid = Auth.auth().currentUser?.uid
        
        // Single fetch of current user
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            // Adding user to UI
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.playerName.text = dictionary["name"] as? String
                self.navigationItem.title = dictionary["name"] as? String
                
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                
                    self.myImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    self.imageLayout()
                }
                
                // Default values
                self.winScoreLabel.text = "0"
                self.drawScoreLabel.text = "0"
                self.loseScoreLabel.text = "0"
                
                self.winScoreLabel.text = dictionary["win"] as? String
                self.drawScoreLabel.text = dictionary["draw"] as? String
                self.loseScoreLabel.text = dictionary["lose"] as? String

            }
            
            self.addPointsToLabels()
            self.addPercentToLabels()
            
        }, withCancel: nil)
    }
    

    func imageLayout() {
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.layer.cornerRadius = 24
        myImageView.layer.masksToBounds = true
        myImageView.contentMode = .scaleAspectFit
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        // if logged out, present Log In screen
        //let logInVC = LogInVC()
        //present(logInVC, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: identifiersStoryboard.Main.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifiersStoryboard.Onboarding.rawValue) as! LogInVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func addPointsToLabels() {
        winScoreLabel.text = "0"
        drawScoreLabel.text = "0"
        loseScoreLabel.text = "0"
        if let win = Int(winScoreLabel.text!), let draw = Int(drawScoreLabel.text!), let lose = Int(loseScoreLabel.text!) {
            pointsWin = win
            pointsDraw = draw
            pointsLose = lose
        }

        pointsTotal = pointsLose + pointsDraw + pointsWin
        totalScoreLabel.text = String(pointsTotal)
    }
    
    func addPercentToLabels() {
        if pointsWin != 0 || pointsTotal != 0 {
            percentWin = Double(pointsWin / pointsTotal)
        }
        
        if pointsDraw != 0 || pointsTotal != 0 {
            percentDraw = Double(pointsDraw / pointsTotal)

        }
        
        if pointsLose != 0 || pointsTotal != 0 {
            percentLose = Double(pointsLose / pointsTotal)

        }
        
        winPercentLabel.text = String(percentWin) + " %"
        drawPercentLabel.text = String(percentDraw) + " %"
        losePercentLabel.text = String(percentLose) + " %"
    }
    
    // MARK: Image Picker
    
    // Amend image of logged in user
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        myImageView.image = image
        //playerImage.setImage(image, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
