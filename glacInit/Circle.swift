//
//  Circle.swift
//  glacInit
//
//  Created by Parshav Chauhan on 5/30/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

struct Circle {
    var frame: CGRect
    var color: UIColor = UIColor.red
    var title: String
    
    init(title t : String, frame f : CGRect) {
        frame = f
        title = t
    }
}
