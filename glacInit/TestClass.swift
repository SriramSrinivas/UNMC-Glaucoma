//
//  TestClass.swift
//  glacInit
//
//  Created by Parshav Chauhan on 6/5/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

class TestClass : UIView{
    
    let view = UIButton()
    var customViewID = 0
    var editMode = true
    
    override init(frame: CGRect) {
        view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor(hexString: "F44556").cgColor
        
        super.init(frame: frame)
        
        let pinchZoom = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchZoom))
        addGestureRecognizer(pinchZoom)
        
        addSubview(view)
    }
    
    func handlePinchZoom(_ gestureRecognizer: UIPinchGestureRecognizer){
        print("pinched \(gestureRecognizer.scale)")
    
        frame.size.height = 200*(gestureRecognizer.scale)
        frame.size.width = 200*(gestureRecognizer.scale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
