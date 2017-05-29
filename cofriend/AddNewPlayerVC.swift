//
//  AddNewPlayerVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
class AddNewPlayerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addButtonsToTextField(field: myTextField)
        setViewLayout(view: self.view)
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
    
    }
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var myTextField: UITextField!
    var keyBoardIsActive: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        // Activate keyboard
        myTextField.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
    }

    
    // MARK: Actions
    
    @IBAction func cancelActionButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneActionButton(_ sender: UIButton) {
        if let text = myTextField.text {
            checkUserAndSaveUserData(text: text)
        }
    }
    
    
    @IBAction func dismissView(_ sender: UIButton) {
        if keyBoardIsActive == false {
            dismiss(animated: true, completion: nil)
        } else {
            myTextField.resignFirstResponder()
            keyBoardIsActive = false
        }
    }
    

    // MARK: Functions
    
    
    @objc func myTargetFunction() {
        // user touch field
        self.keyBoardIsActive = true        
    }
    
    // Done button added to textfield
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let toolBar = UIToolbar()
    
    
    func addButtonsToTextField(field: UITextField) {
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        field.inputAccessoryView = toolBar
        toolBar.sizeToFit()
    }
    
    func cancelClicked() {
        myTextField.resignFirstResponder()
    }
    
    func doneClicked() {
        myTextField.resignFirstResponder()
    }
    
    
    func checkUserAndSaveUserData(text: String) {
        if checkUsername(text: text) == true {
            showAlert(title: "Username already exist", message: "Please try again", dismissButton: "Cancel", okButton: "Ok")
        } else if myTextField.text == "" {
            showAlert(title: "Missing Username", message: "Please try again", dismissButton: "Cancel", okButton: "Ok")
        } else {
            if let image = addPhoto.image(for: .normal) {
                if let user = StoredUserData(username: text, image: image, id: idForUserData) {
                    
                    addUserData.append(user)
                    saveUserData()
                    idForUserData += 1
                    
                    // Save id
                    UserDefaults.standard.set(String(idForUserData), forKey: forKey.UsernameDataId.rawValue)
                    
                    // Dismiss view
                    dismiss(animated: true, completion: nil)
                }
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

    // MARK: Alert
    
    func alertOkFunctions() {
        
    }
    
    func alertDismissFunctions() {

    }
    
    func showAlert(title: String, message: String, dismissButton: String, okButton: String) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.alertOkFunctions()
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel logic here")
            self.alertDismissFunctions()
            
        })
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
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
        
        addPhoto.setImage(image, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
