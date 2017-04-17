//
//  StoryboardDataModel.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-03-29.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

// Safe typing for all storyboards
extension UIStoryboard {
    enum Storyboard: String {
        case main
        var filename: String {
            return rawValue.capitalized
        }
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }
