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
 * Code written by Lyle Reinholz.
 */

import Foundation

func changeCustomViewUpdate(customView: inout CustomViewUpdate, value: Int, effect: effectType, constimage: UIImage?, mainImgView: UIView?){
    customView.layer.zPosition = 2
    customView.blur.blurRadius = 5
    let dvalue = CGFloat(value)/10
    if effect == effectType.blur {
        customView.blur.backgroundColor = UIColor.clear
        customView.blur.alpha = 1
        customView.setValue(value: value)
        customView.blur.blurRadius = CGFloat(value)
        customView.effect = effectType.blur
    } else if effect == .grey {
        customView.blur.backgroundColor = UIColor.black
        customView.setValue(value: value)
        customView.blur.alpha = dvalue
        customView.blur.blurRadius = 0
        customView.effect = effectType.grey
    } else if effect == .color {
        var cropImage = constimage
        customView.setImageConst(images: constimage!)
        customView.setValue(value: value)
        var newView : CGRect
        if (customView.frame.height > customView.frame.width){
            newView = CGRect(x: customView.frame.minX, y: customView.frame.minY, width: customView.frame.height, height: customView.frame.height)
        } else {
            newView = CGRect(x: customView.frame.minX, y: customView.frame.minY, width: customView.frame.width, height: customView.frame.width)
        }
        cropImage = cropImage?.crop(rect: newView)
       // cropImage = cropToBounds(image: constimage!, width: Double(customView.frame.height), height: Double(customView.frame.width), x: customView.frame.minX, y: customView.frame.minY)
        cropImage = cropImage?.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(value)), blendMode: .luminosity)
        mainImgView?.insertSubview(customView, belowSubview: customObjectList.first ?? mainImgView!)
        customView.backgroundColor = .clear
        mainImgView?.layoutSubviews()
        customView.setValue(value: Int(value))
        customView.blur.alpha = dvalue
        customView.blur.blurRadius = 0
        customView.effect = effectType.color
        if (dvalue < 0.1){
            customView.resetImage()
        }
        else{
            customView.resetImage()
            customView.addImage(images: cropImage!)
            
            
        }
    }
    customView.image.clipsToBounds = false
   // customView.contentMode = .scaleAspectFit
    //customView.contentMode = .bottomLeft
    customView.layer.masksToBounds = false
    customView.includesEffect()
}
func captureScreen(view: UIView) -> UIImage? {
    guard let context = UIGraphicsGetCurrentContext() else { return .none }
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
    view.layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

func processData(boxitems: [BOXItem]) -> [ExpandableNames]{
    var twoDArray : [ExpandableNames] = []
    var fileItems: [BoxItemsData] = []
    var folderItems: [BoxItemsData] = []
    for items in boxitems {
        let changedata = BoxItemsData(boxItem: items)
        if changedata.isFolder {
            folderItems.append(changedata)
        } else {
            fileItems.append(changedata)
        }
    }
    //let newArray = ExpandableNames(isExpanded: true, items: folderItems!)
    twoDArray.append(ExpandableNames(isExpanded: true, items: folderItems))
    twoDArray.append(ExpandableNames(isExpanded: true, items: fileItems))
    
    return twoDArray
}
func cropToBounds(image: UIImage, width: Double, height: Double, x : CGFloat, y : CGFloat) -> UIImage {
    
    let cgimage = image.cgImage!
    let contextImage: UIImage = UIImage(cgImage: cgimage)
    let contextSize: CGSize = contextImage.size
    var posX: CGFloat = x
    var posY: CGFloat = y
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
//    if (width >= height ){
//        cgwidth = CGFloat(width)
//        cgheight = CGFloat(width)
//    } else {
//        cgwidth = CGFloat(height)
//        cgheight = CGFloat(height)
//    }
//
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = cgimage.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
}
