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
import CoreImage
import CoreGraphics

class LoadedImageViewController: UIViewController {
    
    var mainImageView : UIImageView = {
       var temp = UIImageView()
        var image = UIImage(named: "mainTes")
        imageViewSetUp(&temp, image: image!)
        temp.image = UIImage(named: "mainTes")
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        return temp
    }()
    
    var sideImageView: UIImageView = {
       var temp = UIImageView()
        temp.backgroundColor = UIColor.darkGray
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    var blurSwitch : UISwitch = {
        let origSwitch = UISwitch(frame:CGRect(x: 0, y: 0, width: 100, height: 50))
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(grewSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()

    var blackSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(blackSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var colorSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(colorSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var isHiddenSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.addTarget(self, action: #selector(isHiddenSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var allSwitch : UISwitch = {
        let origSwitch = UISwitch()
        
        origSwitch.addTarget(self, action: #selector(allSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    var gridSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.addTarget(self, action: #selector(allSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var greyLabel : UITextView = {
       var temp = UITextView()
        nonEditableTextView(&temp, text: "Grey", fontSize: 15)
        return temp
    }()
    
    var blackLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Black", fontSize: 15)
        return temp
    }()
    
    var colorLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Color", fontSize: 15)
        return temp
    }()
    
    var allLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "isHidden", fontSize: 15)
        return temp
    }()
    
    var isHiddenLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "All", fontSize: 15)
        return temp
    }()
    var gridLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Grid", fontSize: 15)
        return temp
    }()
    
    var backButton : UIButton = {
        var temp = UIButton()
        setUpButton(&temp, title: "Back", cornerRadius: 25, borderWidth: 0, color: "red")
        return temp
    }()
    
    
     var greyCustomViewUpdateList = [CustomViewUpdate]()
     var blurCustomViewUpdateList = [CustomViewUpdate]()
     var colorCustomViewUpdateList = [CustomViewUpdate]()
     var objectCustomViewUpdateList = [CustomViewUpdate]()
    
    var fileTypes = [1,2,3]
    var constImage = UIImage(named: "mainTes")
    
    var gridViews = [UIView]()
    let distances =  [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .red
//        view.addSubview(mainImageView)
        [sideImageView, mainImageView, greyLabel, blurSwitch, blackLabel, blackSwitch, colorLabel, colorSwitch, allLabel, allSwitch, isHiddenLabel, isHiddenSwitch, gridLabel, gridSwitch].forEach {view.addSubview($0)}
        initCustomObjects(h: 0, w: 0)
        //view.addSubview(sideImageView)
        setUpView()
        addblur()
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = width  / size.width
        let heightRatio = height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * heightRatio)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
    func addblur(){
        let midx = ((view.frame.width/5)*4)/2
        let midy = view.frame.height/2
        let width = (view.frame.width/5)*4
        let height = view.frame.height
        
        constImage = resizeImage(image: constImage!, width: width, height: height + 1)
        
        for number in distances {
            for numb in distances {
                
                let x = ((numb/2) * Double(width) + Double(midx))
                let y = ((number/2) * Double(height) + Double(midy))
                let rectWidth = (numb.nextUp * Double(width) + Double(midx))/2 - x
                let frame = CGRect(x: x, y:y, width: 15, height: 15)
//                let c = CustomViewUpdate(frame: frame)
//
//                c.isActive = false
//                c.blur.layer.borderWidth = 1
                
                if fileTypes.contains(1){
                    let c = CustomViewUpdate(frame: frame)
                    
                    c.isActive = false
                    c.blur.layer.borderWidth = 1
                    c.layer.zPosition = 2
                    c.blur.blurRadius = 7
                    c.isActive = false
                    c.includesEffect()
                    blurCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                if fileTypes.contains(2){
                    let c = CustomViewUpdate(frame: frame)
                    c.layer.zPosition = 2
                    c.isActive = false
                    c.blur.layer.borderWidth = 1
                    c.blur.backgroundColor = UIColor.black
                    c.blur.alpha = 1/10
                    c.blur.blurRadius = 0
                    greyCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                if (fileTypes.contains(3)){
                    let c = CustomViewUpdate(frame: frame)
                    //value = value/10
                    var cropImage = constImage
                    //let temp = getCurrentActiveView()
                    c.setImageConst(images: constImage!)
                    c.blur.layer.borderWidth = 1

                    cropImage = cropImage!.crop(rect: c.frame)
                    cropImage = cropImage?.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(8)), blendMode: .luminosity)
                    //m//ainImageView.insertSubview(c, belowSubview: customObjectList.first!)
                    //        self.view.layer.zPosition = 1;
                    //temp.layer.zPosition =
                    if ((cropImage) != nil){
                        c.addImage(images: cropImage!)
                    }
                    
                    c.blur.backgroundColor = nil
                    colorCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
            }
        }
        
//        let c = CustomGreyView(frame: frame)
//
//        mainImageView.addSubview(c)
    }
    
    private func setUpView(){
        
        mainImageView.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .zero, size: .init(width: view.frame.width - view.frame.width/5, height: view.frame.height))
        sideImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.rightAnchor, padding: .zero, size: .init(width: view.frame.width/5, height: view.frame.height))
        greyLabel.anchor(top: sideImageView.topAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        blurSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 150, width: 100, height: 50)
        
        blackLabel.anchor(top: greyLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        blackSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 225, width: 100, height: 50)
        colorLabel.anchor(top: blackLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        colorSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 300, width: 100, height: 50)
        
        allLabel.anchor(top: colorLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        allSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 375, width: 100, height: 50)
         isHiddenLabel.anchor(top: allLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        isHiddenSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 450, width: 100, height: 50)
        
        gridLabel.anchor(top: isHiddenLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        gridSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 525, width: 100, height: 50)
    }
    
    func initCustomObjects(h:CGFloat, w:CGFloat){
        
        customObjectList = createobjects(pictureID: 1, height: 0, width: 0)
        
        for i in customObjectList {
            i.isUserInteractionEnabled = true
           // let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleCustomObjectTap))
           // i.addGestureRecognizer(gestureTap)
            
            mainImageView.addSubview(i)
            mainImageView.bringSubviewToFront(i)
        }
    }
    
    @objc func grewSwitch(_sender: UISwitch){
        if (allSwitch.isOn == true)
        {
            allSwitch.setOn(false, animated: true)
        }
        if (_sender.isOn == true){
            for i in blurCustomViewUpdateList{
                i.isHidden = false
            }
        }
        else{
            for i in blurCustomViewUpdateList{
               i.isHidden = true
            }
        }
    }
    @objc func blackSwitch(_sender: UISwitch){
        if (allSwitch.isOn == true)
        {
            allSwitch.setOn(false, animated: true)
        }
        if (_sender.isOn == true){
            for i in greyCustomViewUpdateList{
                i.isHidden = false
            }
        }
        else{
            for i in greyCustomViewUpdateList{
                i.isHidden = true
            }
        }
    }
    @objc func colorSwitch(_sender: UISwitch){
        if (allSwitch.isOn == true)
        {
            allSwitch.setOn(false, animated: true)
        }
        if (_sender.isOn == true){
            for i in colorCustomViewUpdateList{
                i.isHidden = false
            }
        }
        else{
            for i in colorCustomViewUpdateList{
                i.isHidden = true
            }
        }
        
        
    }
    @objc func allSwitch(_sender: UISwitch){
        
        if (_sender.isOn == true){
            blackSwitch.setOn(true, animated: true)
            for i in colorCustomViewUpdateList{
                i.isHidden = false
            }
            blurSwitch.setOn(true, animated: true)
            colorSwitch.setOn(true, animated: true)
            for i in greyCustomViewUpdateList{
                i.isHidden = false
            }
            for i in blurCustomViewUpdateList{
                i.isHidden = false
            }
        }
        else{
            blackSwitch.setOn(false, animated: true)
            blurSwitch.setOn(false, animated: true)
            colorSwitch.setOn(false, animated: true)
            for i in colorCustomViewUpdateList{
                i.isHidden = true
            }
            for i in greyCustomViewUpdateList{
                i.isHidden = true
            }
            for i in blurCustomViewUpdateList{
                i.isHidden = true
            }
        }
    }
    @objc func isHiddenSwitch(_sender: UISwitch){
        if (_sender.isOn == true){
            for i in customObjectList{
                i.isHidden = false
                i.layer.borderWidth = 0
            }
        }
        else{
            for i in customObjectList{
                i.layer.borderWidth = 1
                i.layer.borderColor = UIColor.red.cgColor
                i.isHidden = true
            }
        }
    }
}
enum fileTypes{
    case blur, grey, color, isHidden
}
