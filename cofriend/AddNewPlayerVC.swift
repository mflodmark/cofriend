//
//  AddNewPlayerVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class AddNewPlayerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonsToTextField(field: myTextField)
        setViewLayout(view: self.view)
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        // Default
        addPhoto.isHidden = true
        myTextField.isHidden = true
    
    }
    
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var doneOutlet: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myTextField: UITextField!
    
    var keyBoardIsActive: Bool = false
    var filteredData = [UserClass]()
    var inSearchMode = false
    
    override func viewWillAppear(_ animated: Bool) {
        // Activate keyboard
        myTextField.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.touchDown)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done


    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
        
    }

    
    // MARK: Actions
    
    @IBAction func segmentedControlToggle(_ sender: UISegmentedControl) {
        toggle()
    }
    
    @IBAction func cancelActionButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneActionButton(_ sender: UIButton) {
        if myTextField.text == "" {
            showAlert(title: "Missing Username", message: "Please try again", dismissButton: "Cancel", okButton: "Ok", sender: "checkTextField")
        } else if let text = myTextField.text {
            handleRegister(text: text)
            dismiss(animated: true, completion: nil)
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
    
    func saveFriend(id: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        databaseRef.child("Users/\(uid!)/Friends").updateChildValues([id:true])
        databaseRef.child("Users/\(id)/Friends").updateChildValues([uid!:true])

    }
    
    func handleRegister(text: String) {
        // Make global
        /*
        if checkName() == false {
            showAlert(title: "Not a unique name", message: "Plese try again", dismissButton: "Cancel", okButton: "Ok")
            return
        }*/
        
        // Create user

            
        //successfully authenticated user
        let imageName = NSUUID().uuidString
        
        // Create folder profile_images
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        // Selecting image, uploading using jpeg to minimize image size
        if let profileImage = self.addPhoto.image(for: .normal), let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            // Uploading image
            storageRef.putData(uploadData, metadata: nil, completion: {
                
                (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let values = ["name": text, "email": "notAvailable", "profileImageUrl": profileImageUrl, "win": "0", "lose": "0", "draw": "0"] as [String : Any]
                    
                    let ref = Database.database().reference()
                    let usersReference = ref.child("Users").childByAutoId()
                    let newId = usersReference.key
                    usersReference.setValue(values)
                    
                    self.saveFriend(id: newId)
                }
            })
        }
    }
    
    
    
    func toggle() {
        if segmentedControl.selectedSegmentIndex == 0 {
            addPhoto.isHidden = true
            myTextField.isHidden = true
            myTableView.isHidden = false
            searchBar.isHidden = false
            
        } else {
            addPhoto.isHidden = false
            myTextField.isHidden = false
            myTableView.isHidden = true
            searchBar.isHidden = true
            
        }
    }
        
    
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
    



    // MARK: Alert
    
    func alertOkFunctions(sender: String) {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        if sender == "checkSelectedCell" {
            if let uid = Auth.auth().currentUser?.uid, let id = friend.id {
                databaseRef.child("Users/\(uid)/Friends").updateChildValues([id:"SentFriendRequest"])
                databaseRef.child("Users/\(id)/Friends").updateChildValues([uid:"ReceivedFriendRequest"])
            }
        }
    }
    
    func alertDismissFunctions() {
        
    }
    
    func showAlert(title: String, message: String, dismissButton: String, okButton: String, sender: String) {
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: okButton, style: .default, handler: { (action: UIAlertAction!) in
            self.alertOkFunctions(sender: sender)
            
        })
        alertController.addAction(actionOk)
        
        let actionCancel = UIAlertAction(title: dismissButton, style: .cancel, handler: { (action: UIAlertAction!) in
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
    
    // MARK: - Table view data source
    
    //tells the table view how many sections to display.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Each meal should have its own row in that section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredData.count
        }
        
        return users.count
    }
    
    //only ask for the cells for rows that are being displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = identifiersCell.PlayerCell.rawValue
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserCell {
            
            // Fetches the appropriate data for the data source layout.
            var user = users[indexPath.row]

            if inSearchMode {
                user = filteredData[indexPath.row]
                cell.alpha = 1
            }
            
            cell.myLabel.text = user.name
            
            if let profileImageUrl = user.profileImageUrl {
                cell.myImage.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            
            
            // Cell status
            tableView.allowsMultipleSelection = true
            // Don't show users
            cell.alpha = 0
            
            return cell
        } else {
            
            return UITableViewCell()
        }
    
    }
    
    var friend: UserClass = UserClass(dictionary: ["":"" as AnyObject])
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = users[(indexPath as NSIndexPath).row]
        friend = selectedCell
        
        if let friendName = friend.name {
            showAlert(title: "Friend request", message: "Do you want to send a friend request to \(friendName)?", dismissButton: "No", okButton: "Yes", sender: "checkSelectedCell")
        }
    }
    
    
    // MARK: Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            view.endEditing(true)
            
            myTableView.reloadData()
            
        } else {
            
            inSearchMode = true
            
            filteredData = users.filter({$0.name == searchBar.text!})
            
            myTableView.reloadData()
        }
    }
    
}
