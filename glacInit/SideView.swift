//
// Created by Parshav Chauhan on 3/14/17.
// Copyright (c) 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class SideView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#424242")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}