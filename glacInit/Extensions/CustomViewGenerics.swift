//
//  CustomViewGenerics.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/7/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

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
        cropImage = cropImage?.crop(rect: customView.frame)
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