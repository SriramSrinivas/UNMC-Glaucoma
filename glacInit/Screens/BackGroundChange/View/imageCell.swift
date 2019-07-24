//
//  imageCell.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/1/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

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
            imageView.image  = UIImage(named: (imageAt?.BackgroundimageName)!)
        }
    }
    
    let imageView : UIImageView = {
        let temp = UIImageView()
        //temp.image = UIImage(named: "tes")
        temp.layer.cornerRadius = 35
        temp.layer.borderColor = UIColor.gray.cgColor
        temp.layer.borderWidth = 5
        temp.clipsToBounds = true
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
