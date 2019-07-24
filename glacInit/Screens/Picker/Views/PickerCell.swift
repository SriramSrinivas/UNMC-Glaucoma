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
        selectButton.frame = CGRect(x: 0, y: 0, width: 75, height: 50)
        selectButton.backgroundColor = .blue
        selectButton.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        
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
