//
//  PickerCell.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/23/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation

class PickerCell: UITableViewCell {
    
    var link: PickerView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select", for: .normal)
        selectButton.setTitleColor(UIColor.darkGray, for: .normal)
        selectButton.frame = CGRect(x: 0, y: 0, width: 75, height: 50)
        selectButton.backgroundColor = UIColor(red:0.27, green:0.64, blue:0.62, alpha:1.0)
        selectButton.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        selectButton.layer.cornerRadius = 10
        
        
//        backgroundColor = .red
        
        accessoryView = selectButton
    }
    
    @objc func handleSelect() {
        link?.someMethodCall(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
