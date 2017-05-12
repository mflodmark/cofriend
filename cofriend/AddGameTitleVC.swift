//
//  AddGameTitleVC.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-02.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class AddGameTitleVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBOutlet weak var myTextField: UITextField!
        
    // MARK: Actions
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        prepareSavingData()
        saveGameTitleData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Functions
    
    func prepareSavingData() {
        if let text = myTextField.text, let tournament = selectedTour?.tournamentTitle {
            let game = StoredGameTitleData(tournamentTitle: tournament, scoreTitle: text, id: idForGameTitle)
            
            addGameTitle.append(game!)
            
            idForGameTitle += 1
            // Save id
            UserDefaults.standard.set(String(idForGameTitle), forKey: forKey.GameTitleId.rawValue)
        }
    }
    
    // MARK: Segue
    
    
    
}
