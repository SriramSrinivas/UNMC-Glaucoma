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
        customView.setBlurValue(value: value)
        customView.blur.blurRadius = CGFloat(value)
        if (!customView.effect.contains(effectType.blur)){
        customView.effect.append(effectType.blur)
        }
       // customView.blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
    } else if effect == .grey {
        //customView.backgroundColor = UIColor.black
        customView.setGreyValue(value: value)
        customView.greyRect.alpha = dvalue
        customView.greyRect.backgroundColor = .black
       // customView.blurRadius = 1
        if (!customView.effect.contains(effectType.grey)){
            customView.effect.append(effectType.grey)
        }
       // customView.blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
        //customView.isActive = true
    } else if effect == .color {
        //customView.image.frame = customView.frame
        var cropImage = constimage
        customView.setImageConst(images: constimage!)
        customView.setColorValue(value: value)
        var newView : CGRect
        if (customView.frame.height > customView.frame.width){
         // since width was being bounded this while loops took multiple images and stacks one atop of the other
            var height = CGFloat(0)
            newView = CGRect(x: customView.frame.minX, y: customView.frame.minY, width: customView.frame.width, height: customView.frame.width)
            while (height <= customView.frame.height) {
                cropImage = constimage
                newView = CGRect(x: customView.frame.minX, y: customView.frame.minY + height, width: customView.frame.width, height: customView.frame.width)
                let imageview = UIImageView(frame: CGRect(x: 0, y: height, width: customView.frame.width, height: customView.frame.width))
                height = customView.frame.width + height
                cropImage = cropImage?.crop(rect: newView)
                cropImage = cropImage?.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(value)), blendMode: .luminosity)
                imageview.image = cropImage
                customView.addSubview(imageview)
                
            }
           
        } else {
            newView = CGRect(x: customView.frame.minX, y: customView.frame.minY, width: customView.frame.width, height: customView.frame.width)
            cropImage = cropImage?.crop(rect: newView)
            cropImage = cropImage?.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(value)), blendMode: .luminosity)
        }
     
        mainImgView?.insertSubview(customView, belowSubview: customObjectList.first ?? mainImgView!)
        customView.backgroundColor = .clear
        mainImgView?.layoutSubviews()
        customView.setColorValue(value: Int(value))
        customView.blur.alpha = dvalue
        customView.blur.blurRadius = 0
        if (!customView.effect.contains(effectType.color)){
            customView.effect.append(effectType.color)
        }
        if (dvalue < 0.1){
            customView.resetImage()
        }
        else{
            customView.resetImage()
            customView.addImage(images: cropImage!)
        }
    }
    customView.image.clipsToBounds = true
    customView.image.contentMode = .scaleAspectFill
//    customView.blur.contentMode = .scaleAspectFill
//    customView.blur.clipsToBounds = true
 
    //customView.blur.layer.borderWidth = 0
  
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
        if changedata.isFolder && changedata.name == "GlaucomaApp" {
            folderItems.append(changedata)
        } else {
            ///fileItems.append(changedata)
        }
    }
    //let newArray = ExpandableNames(isExpanded: true, items: folderItems!)
    twoDArray.append(ExpandableNames(isExpanded: true, items: folderItems))
    twoDArray.append(ExpandableNames(isExpanded: true, items: fileItems))
    
    return twoDArray
}
extension UIImage {
    
    func cropToRect(rect: CGRect!) -> UIImage? {
        
        let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.size.width * self.scale, height: rect.size.height * self.scale);
        
        
        guard let imageRef: CGImage = self.cgImage?.cropping(to:scaledRect)
            else {
                return nil
        }
        
        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}

func topBorder(view: UIView) {
    let border = UIView()
    border.backgroundColor = .red
    border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 5)
    view.addSubview(border)
}
func botBorder(view: UIView) {
    let border = UIView()
    border.backgroundColor = .red
    border.frame = CGRect(x: 0, y: view.frame.height - 5, width: view.frame.width, height: 5)
    view.addSubview(border)
}
func rightBorder(view: UIView) {
    let border = UIView()
    border.backgroundColor = .red
    border.frame = CGRect(x: view.frame.width - 5, y: 0, width: 5, height: view.frame.height)
    view.addSubview(border)
}
func leftBorder(view: UIView) {
    let border = UIView()
    border.backgroundColor = .red
    border.frame = CGRect(x: 0, y: 0, width: 5, height: view.frame.height)
    view.addSubview(border)
}
