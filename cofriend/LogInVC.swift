//
//  LogInVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-30.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class LogInVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    
    var playerVC: PlayerViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerOutlet.setTitle("Log In", for: .normal)
        usernameTextField.isHidden = true
        
        addButtonsToTextField(field: usernameTextField)
        addButtonsToTextField(field: passwordTextField)
        addButtonsToTextField(field: emailTextField)

    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textFieldStack: UIStackView!
    @IBOutlet weak var userImage: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerOutlet: UIButton!
    
    @IBAction func regiesterButton(_ sender: UIButton) {
        handleLoginRegister()
    }
    
    @IBAction func segmentedControlToggle(_ sender: UISegmentedControl) {
        toggle()
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
    
    }
    
    // MARK: Log In
    
    func toggle() {
        if segmentedControl.selectedSegmentIndex == 0 {
            usernameTextField.isHidden = true
            forgotPasswordButton.isHidden = false
            registerOutlet.setTitle("Log In", for: .normal)
            
        } else {
            usernameTextField.isHidden = false
            forgotPasswordButton.isHidden = true
            registerOutlet.setTitle("Register", for: .normal)

        }
    }
    
    func handleLoginRegister() {
        if segmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        // Sign in
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error)
                print("Log in didn't work")
                return
            }
            
            // Fetch user again
            self.playerVC?.fetchUser()
            
            //successfully logged in our user
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    func handleRegister() {
        
        if checkName() == true {
            showAlert(title: "Not a unique name", message: "Plese try again", dismissButton: "Cancel", okButton: "Ok")
            return
        }
        if checkEmail() == true {
            showAlert(title: "Not a unique email", message: "Plese try again", dismissButton: "Cancel", okButton: "Ok")
            return
        }
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = usernameTextField.text else {
            print("Form is not valid")
            return
        }

        // Create user
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            
            // Create folder profile_images
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            // Selecting image, uploading using jpeg to minimize image size
            if let profileImage = self.userImage.image(for: .normal), let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                // Uploading image
                storageRef.putData(uploadData, metadata: nil, completion: {
                    
                    (metadata, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "win": "0", "lose": "0", "draw": "0"]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })

            
            }
            
        })
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("Users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            // Fetch user again
            self.playerVC?.fetchUser()
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    // MARK: Functions
    
    func checkEmail() -> Bool {
        let checked = false
        
        return checked
    }
    
    func checkName() -> Bool {
        let checked = false
        
        return checked
    }
    
    // Done button added to textfield
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let toolBar = UIToolbar()
    
    
    func addButtonsToTextField(field: UITextField) {
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        field.inputAccessoryView = toolBar
        toolBar.sizeToFit()
    }
    
    
    func doneClicked() {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
        
        userImage.setImage(image, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    
    
}
