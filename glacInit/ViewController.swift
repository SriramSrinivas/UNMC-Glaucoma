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
    let blurButton = UIButton()
    let blackButton = UIButton()
    let undoButton = UIButton()
    var isBlur: Bool = false
    var isBlack: Bool = false
    var tag = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
        let sideView = UIView(frame: CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))
        sideView.backgroundColor = UIColor.blue

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)
        addBlurButton(sideView: sideView)
        addBlackButton(sideView: sideView)
        addUndoButton(sideView: sideView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBlur(xLoc: CGFloat, yLoc: CGFloat){

        let d = UIView(frame: CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 150, height: 150))

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = d.frame
        //blurEffectView.alpha = 0.8

        blurEffectView.tag = tag
        tag += 1

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(blurEffectView)
    }

    func addBlack(xLoc: CGFloat, yLoc: CGFloat){

        let d = UIView(frame: CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 150, height: 150))
        d.backgroundColor = UIColor.black

        d.tag = tag
        tag += 1

        self.view.addSubview(d)
    }
    
    func loadImage(mainImgView: UIView){

        let image = UIImage(named: "tes");
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        imageView.image = image
        //imageView.contentMode = UIViewContentMode.scaleAspectFit
        mainImgView.addSubview(imageView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func addBlurButton(sideView: UIView){

        let screenHeight = screenSize.height
        
        blurButton.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight/8, width: 100, height: 100)
        blurButton.backgroundColor = UIColor.green
        blurButton.layer.cornerRadius = blurButton.frame.size.width/2
        blurButton.addTarget(self, action: #selector(blurTap), for: .touchUpInside)
        sideView.addSubview(blurButton)
    }

    func addBlackButton(sideView: UIView){

        let screenHeight = screenSize.height

        blackButton.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight/3, width: 100, height: 100)
        blackButton.backgroundColor = UIColor.gray
        blackButton.layer.cornerRadius = blurButton.frame.size.width/2
        blackButton.addTarget(self, action: #selector(blackTap), for: .touchUpInside)
        sideView.addSubview(blackButton)
    }

    func addUndoButton(sideView: UIView){

        let screenHeight = screenSize.height

        undoButton.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight/2, width: 100, height: 100)
        undoButton.backgroundColor = UIColor.red
        undoButton.layer.cornerRadius = blurButton.frame.size.width/2
        undoButton.addTarget(self, action: #selector(undoTap), for: .touchUpInside)
        sideView.addSubview(undoButton)
    }
    
    func blurTap(sender: UIButton!) {
        isBlur = true
        isBlack = false
        makeBorder(btn: blurButton)
        removeBorder(btn: blackButton)
    }

    func blackTap(sender: UIButton!){
        isBlur = false
        isBlack = true
        makeBorder(btn: blackButton)
        removeBorder(btn: blurButton)
    }

    func undoTap(sender: UIButton!){
        let viewWithTag = self.view.viewWithTag(tag - 1)
        viewWithTag?.removeFromSuperview()
        if(tag != 1) {
            tag -= 1
        }
    }

    func makeBorder(btn: UIButton){
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.white.cgColor
    }

    func removeBorder(btn: UIButton){
        btn.layer.borderWidth = 0
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let touchPoint = tapGestureRecognizer.location(in: tappedImage)

        if(isBlur) {
            addBlur(xLoc: touchPoint.x, yLoc: touchPoint.y)
        }
        else if(isBlack) {
            addBlack(xLoc: touchPoint.x, yLoc: touchPoint.y)
        }
    }
}

