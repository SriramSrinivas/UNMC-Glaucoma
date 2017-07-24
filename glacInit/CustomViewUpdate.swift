//
//  CustomViewUpdate.swift
//  glacInit
//
//  Created by Parshav Chauhan on 6/9/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import VisualEffectView
import UIKit

class CustomViewUpdate : UIView{
    
    let blur = VisualEffectView()
    var isActive: Bool = false
    var isLinkedToImage: Bool = false
    var linkedImage = UIView()
    var alphaValue = CGFloat(1)
    var greyValue = CGFloat(0)
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        blur.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        blur.blurRadius = 0
        blur.layer.borderWidth = 5
        isActive(value: true)
        
        let panRecog = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pinchZoom = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchZoom))

        addGestureRecognizer(pinchZoom)
        addGestureRecognizer(panRecog)
        
        addSubview(blur)
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
    
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if isActive{
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            }
        }
    }
    
    func handlePinchZoom(_ gestureRecognizer: UIPinchGestureRecognizer){
        
        if isActive {
                frame.size.height = 200*(gestureRecognizer.scale)
                frame.size.width = 200*(gestureRecognizer.scale)
                blur.frame.size.height = 200*(gestureRecognizer.scale)
                blur.frame.size.width = 200*(gestureRecognizer.scale)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
