//
//  CustomPoint.swift
//  glacInit
//
//  Created by Parshav Chauhan on 7/27/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class CustomPoint : UIView {
    
    init(point: CGPoint){
        
        super.init(frame: CGRect(x: point.x, y: point.y, width: 7, height: 7))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
