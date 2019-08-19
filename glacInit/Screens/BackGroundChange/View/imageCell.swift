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

import UIKit

class Basecell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ChangeCell : Basecell {
    
    var imageAt : BackgroundImage? {
        didSet {
            imageView.image  = (imageAt?.Backgroundimage)!
            
        }
    }
    
    let imageView : UIImageView = {
        let temp = UIImageView()
        //temp.image = UIImage(named: "tes")
        temp.layer.cornerRadius = 35
        temp.layer.borderColor = UIColor.gray.cgColor
        temp.layer.borderWidth = 5
        temp.clipsToBounds = true
        temp.backgroundColor = UIColor.lightGray
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let seperator : UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(seperator)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": imageView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(5)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : seperator]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(5)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": seperator]))
        
    }
}
