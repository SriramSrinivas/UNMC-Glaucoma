//
//  CustomObject.swift
//  glacInit
//
//  Created by Parshav Chauhan on 5/30/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class CustomObject : UIView {
    
    var imageView = UIView()
    
    init(title: String, alpha: Int) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView = addDoggo(view: imageView)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDoggo(view: UIView) -> UIView{
        
        var image = UIImage(named: "doggo")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 90, height: 90))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        view.frame = CGRect(x: 413, y: 413, width: imageView.frame.size.width, height: imageView.frame.size.height)
        view.backgroundColor = UIColor(patternImage: image!)
        //let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(doggoTap))
        //view.addGestureRecognizer(gestureRecognizer1)
        
        return view
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
