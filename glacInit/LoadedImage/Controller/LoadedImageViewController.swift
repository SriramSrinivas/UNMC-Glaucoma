//
//  LoadedImageViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/8/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

// TODO:
// Load data into CSV'S
// present data using dots or squares or whatever (I think circles would look cool XD)
// have a control bar similar to the viewController but different controls
// controls needed iseditable, which files show. like only blur? grey? ishidden? two of them? or all?
// maybe have a temp storage on device? so they dont have to keep reloading the data


import Foundation
import UIKit

class LoadedImageViewController: ViewController {
    
    var mainImageView : UIImageView = {
       var temp = UIImageView()
        let image = UIImage(named: "Tes")
        //temp = imageViewSetUp(&temp, image: image!)
        return temp
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(<#T##view: UIView##UIView#>)
        setUpView()
    }
    
    private func setUpView(){
        mainImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: (view.frame.size.width - view.frame.size.width/5), height: view.frame.height))
    }
    
}
