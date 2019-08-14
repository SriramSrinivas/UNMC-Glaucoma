/*************************************************************************
 *
 * UNIVERSITY OF NEBRASKA AT OMAHA CONFIDENTIAL
 * __________________
 *
 *  [2018] - [2019] University of Nebraska at Omaha
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of University of Nebraska at Omaha and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to University of Nebraska at Omaha
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from University of Nebraska at Omaha.
 *
 * Code written by Lyle Reinholz and Parshav Chauhan.
 */

import UIKit

class CustomObject : UIView {
    
    var imageView = UIView()
    //var alphaValue = 1
    //var customObjectList = [CustomObject]()
    
    init(imageName: String, xPos: CGFloat, yPos: CGFloat, sideSize: CGFloat, alphaValue: Int) {

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addImage(imageName: imageName, xPos: xPos, yPos: yPos, sideSize: sideSize)
        addSubview(imageView)
        super.frame = self.frame
    }

    init(image: UIImage, xPos: CGFloat, yPos: CGFloat, sideSize: CGFloat, alphaValue: Int) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addImage(images: image, xPos: xPos, yPos: yPos, sideSize: sideSize)
        addSubview(imageView)
        super.frame = self.frame
    }
    func removeImage () {
        imageView.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImage(imageName: String, xPos: CGFloat, yPos: CGFloat, sideSize: CGFloat){
        
        var image = UIImage(named: imageName)
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: sideSize, height: sideSize))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        self.frame = CGRect(x: xPos, y: yPos, width: imageView.frame.size.width, height: imageView.frame.size.height)
        self.backgroundColor = UIColor(patternImage: image!)
    }
    func addImage(images: UIImage, xPos: CGFloat, yPos: CGFloat, sideSize: CGFloat){
        
        var image = images
        
        image = resizeImage(image: image, targetSize: CGSize(width: sideSize, height: sideSize))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image.size.width), height: (image.size.height)))
        imageView.image = image
        
        self.frame = CGRect(x: xPos, y: yPos, width: imageView.frame.size.width, height: imageView.frame.size.height)
        self.backgroundColor = UIColor(patternImage: image)
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
