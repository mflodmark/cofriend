//
//  PlayerViewController.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-28.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class PlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getPlayer()
        addPointsToLabels()
        addPercentToLabels()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Declarations
    
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
    
    // MARK: Functions
    
    func getPlayer() {
        if user == nil {
            // Don't do anything yet
        
        } else {
            // Load Player data
            let name = addUserData[0].username
            playerName.text = name
            
            let image = addUserData[0].image
            playerImage.setImage(image, for: .normal)
        }
        
    }
    
    
    func addPointsToLabels() {
        winScoreLabel.text = String(pointsWin)
        drawScoreLabel.text = String(pointsDraw)
        loseScoreLabel.text = String(pointsLose)
        
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
        
        playerImage.setImage(image, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
