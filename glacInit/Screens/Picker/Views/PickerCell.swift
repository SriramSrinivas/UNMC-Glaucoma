/*************************************************************************
 *
 * UNIVERSITY OF NEBRASKA AT OMAHA CONFIDENTIAL
 * __________________
 *
 *  [2018] - [2019] University of Nebraska at Omaha
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of University of Nebraska at Omaha and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to University of Nebraska at Omaha
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from University of Nebraska at Omaha.
 *
 * Code written by Lyle Reinholz.
 */

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
        
        accessoryView = selectButton
    }
    
    @objc func handleSelect() {
        link?.someMethodCall(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
