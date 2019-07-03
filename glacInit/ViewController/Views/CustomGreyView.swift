//
//  CustomGreyView.swift
//  glacInit
//
//  Created by Parshav Chauhan on 6/15/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class CustomGreyView : UIView{
    
    let v = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        
        backgroundColor = UIColor.black
        alpha = 0.5
        
        let panRecog = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panRecog)
        
        addSubview(v)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            }
    }
}
