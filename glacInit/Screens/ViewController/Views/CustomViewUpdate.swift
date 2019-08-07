//
//  CustomViewUpdate.swift
//  glacInit
//
//  Created by Parshav Chauhan on 6/9/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import VisualEffectView
import UIKit

enum effectType {
    case blur
    case grey
    case isHidden
    case color
    case PNG
    case saveFile
    case IncorrectFileType
}
extension effectType {
    init?(effect: String) {
        if effect == "blur"{
            self = .blur
        } else if effect == "grey" {
            self = .grey
        } else if effect == "isHidden" {
            self = .isHidden
        } else if effect == "color" {
            self = .color
        } else if effect == "saveFile"{
            self = .saveFile
        } else if effect == "PNG"{
            self = .PNG
        } else {
            self = .IncorrectFileType
        }
    }
}

class CustomViewUpdate : UIView{
    
    let blur = VisualEffectView()
    var isActive: Bool = false
    var isLinkedToImage: Bool = false
    var linkedImage = UIView()
    var alphaValue = CGFloat(1)
    var greyValue = CGFloat(0)
    var colorValue = CGFloat(0)
    var valueLabel = UILabel()
    var image = UIImageView()
    var constImage = UIImage()
    var viewValue = 5
    var effect = effectType.blur
    
     let screenSize: CGRect = UIScreen.main.bounds
    override init(frame: CGRect) {
   
        
        super.init(frame: frame)
        //self.frame.
        blur.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        blur.blurRadius = 0
        blur.layer.borderWidth = 5
        isActive(value: true)
        
        effect = effectType.blur
        valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        valueLabel.textAlignment = .center
        valueLabel.text = "5"
        valueLabel.textColor = .green
        
        let panRecog = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pinchZoom = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchZoom))

        addGestureRecognizer(pinchZoom)
        addGestureRecognizer(panRecog)

        image =  UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        blur.contentView.addSubview(image)
        blur.contentView.addSubview(valueLabel)
        addSubview(blur)
    }

    func addImage(images: UIImage){
        image.image = images
    }
    func resetImage()
    {
        image.image = nil
    }
    func getImageFromMain() -> UIImage {
        var cropImage = constImage
        cropImage = cropImage.crop(rect: self.frame)
        cropImage = cropImage.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(viewValue)/10), blendMode: .luminosity)
        return cropImage
    }
    func setImageConst(images: UIImage){
        constImage = images
    }
    func setValue(value: Int){
        viewValue = value
        valueLabel.text = String(value)
    }

    func isActive(value: Bool){
        switch value {
        case true:
            blur.layer.borderWidth = 5
            if isLinkedToImage{
                blur.layer.borderColor = UIColor(hexString: "2196F3").cgColor
            } else {
                blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
            }
            isActive = true
        case false:
            blur.layer.borderWidth = 0
            isActive = false
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if isActive && !(isLinkedToImage){
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        
                image.image? = getImageFromMain()
            }
            
            if(gestureRecognizer.view!.center.x < gestureRecognizer.view!.frame.height/2){
                gestureRecognizer.view!.center.x = gestureRecognizer.view!.frame.height/2
            }
            if(gestureRecognizer.view!.center.y < gestureRecognizer.view!.frame.height/2){
                gestureRecognizer.view!.center.y = gestureRecognizer.view!.frame.height/2
            }
            if(gestureRecognizer.view!.center.x > ((screenSize.width / 5) * 4) - gestureRecognizer.view!.frame.height/2){
                gestureRecognizer.view!.center.x = ((screenSize.width / 5) * 4) - gestureRecognizer.view!.frame.height/2
            }
            if(gestureRecognizer.view!.center.y > (screenSize.height) - gestureRecognizer.view!.frame.height/2){
                gestureRecognizer.view!.center.y = (screenSize.height) - gestureRecognizer.view!.frame.height/2
            }
        }
    }
    
    @objc func handlePinchZoom(_ gestureRecognizer: UIPinchGestureRecognizer){
        if isActive && !(isLinkedToImage){
            let currentCenter = center
            let gesCenter = gestureRecognizer.view?.center
            
            var change = 200*(gestureRecognizer.scale)
            if change > screenSize.size.height {
                change = screenSize.size.height
            }
            if change > gesCenter!.y * 2 {
                change = gesCenter!.y * 2
            }
            if change > gesCenter!.x * 2{
                change = gesCenter!.x * 2
            }
            if change > (screenSize.size.height - gesCenter!.y) * 2  {
                change = (screenSize.size.height - gesCenter!.y) * 2
            }
            if change > (((screenSize.width / 5) * 4) - gesCenter!.x) * 2{
                change = (((screenSize.width / 5) * 4) - gesCenter!.x) * 2
            }
            //MARK: TODO test this 
           
            frame.size.height = change
            frame.size.width = change
            
            blur.frame.size.height = change
            blur.frame.size.width = change
            
            
            
            blur.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            image.frame = blur.frame
            image.image? = getImageFromMain()
            center = currentCenter
           
        }
    }

    func getEffectValue(){

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
