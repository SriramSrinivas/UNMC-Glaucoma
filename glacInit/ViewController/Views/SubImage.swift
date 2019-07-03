//
//  SubImage.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/2/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

class SubImage {
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        //let contextImage: UIImage = UIImage(cgImage: image.cgImage!)

        //let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: UIImage = cropToBounds(image: image, width: width, height: height)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        //let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return imageRef
    }
}
