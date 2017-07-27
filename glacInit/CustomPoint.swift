//
//  CustomPoint.swift
//  glacInit
//
//  Created by Parshav Chauhan on 7/27/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class CustomPoint : UIView {
    
    init(xPos: CGFloat, yPos: CGFloat){
        
        super.init(frame: CGRect(x: xPos, y: yPos, width: 7, height: 7))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
