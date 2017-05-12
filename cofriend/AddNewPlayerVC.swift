//
//  AddNewPlayerVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
class AddNewPlayerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }
    
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        if let text = myTextField.text {
            checkUserAndSaveUserData(text: text)
        }
        saveUserData()
        dismiss(animated: true, completion: nil)
    }

    // MARK: Functions
    
    
    func checkUserAndSaveUserData(text: String) {
        if checkUsername(text: text) == true {
            //showAlert(title: "Username already exist", message: "Please try again", dismissButton: "Cancel", okButton: "Ok", sender: yourImageButton)
        } else {
            if let user = StoredUserData(username: text, image: #imageLiteral(resourceName: "DefaultImage"), id: idForUserData) {
                
                addUserData.append(user)
                saveUserData()
                idForUserData += 1
                
                // Save id
                UserDefaults.standard.set(String(idForUserData), forKey: forKey.UsernameDataId.rawValue)
                
            }
        }
    }
    
    func checkUsername(text: String) -> Bool {
        // starter value
        var checked = false
        for user in addUserData {
            if text == user.username {
                // Username already exists
                checked = true
            }
        }
        return checked
    }

}
