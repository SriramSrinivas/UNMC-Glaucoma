//
//  CustomToggle.swift
//  glacInit
//
//  Created by Parshav Chauhan on 6/14/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class CustomToggle : UIView{
    
    var customSwitch = UISwitch()
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        customSwitch = UISwitch(frame: CGRect(x: frame.origin.x + frame.size.width/6, y: frame.origin.y, width: frame.size.width*0.5, height: frame.size.height))
        
        textLabel = UILabel(frame: CGRect(x: frame.origin.x + frame.size.width*0.5, y: frame.origin.y - 30, width: frame.size.width*0.5, height: frame.size.height))
        textLabel.text = "Grid"
        textLabel.textColor = UIColor.white
        
        addSubview(customSwitch)
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
