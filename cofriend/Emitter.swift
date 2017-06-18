//
//  Emitter.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-06-14.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//


import UIKit


class Emitter {
    class func get(image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    
    class func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 1
        cell.lifetime = 15 // seconds
        cell.velocity = CGFloat(25) // How fast cells are emitted
        cell.emissionLongitude = (180 * (.pi / 180)) // 0° is straight up, 180° is straight down
        cell.emissionRange = (45 * (.pi / 180)) // Variation in emission longitude
        cell.scale = 0.4 // 1 is normal size. < 1 will make it smaller.
        cell.scaleRange = 0.3 // Variation in size
        cells.append(cell)
        
        return cells
    }
}
