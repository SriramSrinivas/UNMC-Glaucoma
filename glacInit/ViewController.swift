//
//  ViewController.swift
//  glacInit
//
//  Created by Parshav Chauhan on 2/11/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        //addBlurButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBlur(xLoc: CGFloat, yLoc: CGFloat){

        let d = UIView(frame: CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 150, height: 150))

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = d.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(blurEffectView)
    }
    
    func loadImage(){

        let image = UIImage(named: "tes");
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!));
        imageView.image = image;
        self.view.addSubview(imageView);

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func addBlurButton(){

        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let btn: UIButton = UIButton(frame: CGRect(x: (screenWidth - screenWidth/6), y: screenHeight/8, width: 100, height: 100))
        btn.backgroundColor = UIColor.green
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.tag = 1
        view.addSubview(btn)
    }
    
    func buttonAction(sender: UIButton!) {
        print("Green Button tapped")
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let touchPoint = tapGestureRecognizer.location(in: tappedImage)

        addBlur(xLoc: touchPoint.x, yLoc: touchPoint.y)
    }
}

