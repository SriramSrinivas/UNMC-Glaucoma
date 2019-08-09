//
//  MainMenuViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/31/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import BoxContentSDK
import Reachability
import PopupDialog

class MainMenuViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //MARK: CLASS VARIABLES
    var imagePicker: UIImagePickerController!
    
    var versionNumber : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "-v 2.2.0", fontSize: 12)
        temp.backgroundColor = .black
        temp.textAlignment = .center
        return temp
    }()

    var mainMenuTitleLabel : UIButton = {
        var temp = UIButton(type: .system)
        //temp.isOpaque = false
        //temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
        setUpButton(&temp, title: "Menu", cornerRadius: 0, borderWidth: 0, color: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5).cgColor)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        
        temp.isEnabled = false
        return temp
    }()
    
    var mainMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Back to Previous", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        return temp
    }()
    
    var logoutMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Box Settings", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(BoxSettingsTapped), for: .touchUpInside)
        return temp
    }()
    
    var importMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Import", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(importMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
    
    var newMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "New Session", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(newMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
 
    
    var switchMenuButton : UIButton = {
        var temp = UIButton(type: .system)
      
        setUpButton(&temp, title: "switch", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(switchMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
    var cameraMenuButton : UIButton = {
        var temp = UIButton(type: .system)
       
        setUpButton(&temp, title: "Camera", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)

        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(cameraMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
   
//    var blurObject : CustomViewUpdate = {
//        let frame = CGRect(x: 0, y:0, width: 0, height: 0)
//        var c = CustomViewUpdate(frame: frame)
//        changeCustomViewUpdate(customView: &c, value: 5, effect: .blur, constimage: nil, mainImgView: nil)
//        c.isActive = false
//        c.blur.layer.borderWidth = 0
//        c.setValue(value: 0)
//        return c
//    }()
    
    var background : UIImageView = {
        var temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: Globals.shared.getCurrentBackGround())
        return temp
    }()
    
    var imageName = Globals.shared.getCurrentBackGround()
     var reach: Reachability!
    var currentSession: Session!
    //MARK: VIEW MANAGEMENT
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(white: 0, alpha: 0.7)
       
        backgroundChanged()
    
        navigationController?.navigationBar.isHidden = true
        [background, mainMenuButton, mainMenuTitleLabel, importMenuButton, newMenuButton, switchMenuButton, cameraMenuButton, logoutMenuButton, versionNumber].forEach {view.addSubview($0)}
        setUpView()
    }
    override func viewDidAppear(_ animated: Bool) {
        backgroundChanged()
    }
    
    //MARK: BUTTON ACTIONS
    
    @objc func MenuTapped(_sender: UIButton){
       self.dismiss(animated: false, completion: nil)
    }
    @objc func importMenuButtonTapped(_sender: UIButton){
        let vc = ImportDataViewController()
        self.present(vc, animated: false, completion: nil)
    }
    @objc func newMenuButtonTapped(_sender: UIButton){
        
        let vc = ViewController()
        //vc.backImageName = imageName
        self.present(vc, animated: true, completion: nil)
    }
//    @objc func startOverMenuButtonTapped(_sender: UIButton){
//        let vc = ViewController()
//        //vc.backImageName = imageName
//        self.present(vc, animated: true, completion: nil)
//    }
    @objc func switchMenuButtonTapped(_sender: UIButton){
        self.parent?.dismiss(animated: true, completion: nil)
        let layout = UICollectionViewFlowLayout()
        let vc = BackgroundChangeController(collectionViewLayout: layout)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
   
    @objc func BoxSettingsTapped(){
        let vc = BoxSettingsPage()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @objc func cameraMenuButtonTapped(){
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
   
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.originalImage] as? UIImage)
        background.image = image
        Globals.shared.setCameraImage(image: image!)
        Globals.shared.setCurrentBackGround(newBack: "camera")
        updateBackground(image: image!)
        imagePicker.dismiss(animated: true, completion: nil)
//        let image = (info[.originalImage] as? UIImage)!
//        Globals.shared.setCameraImage(image: image)
//        Globals.shared.setCurrentBackGround(newBack: "camera")
//        updateBackground()
    }
    
    func updateBackground(image: UIImage){
        
            background.image = image
       
    }
    
    //MARK: SETUPVIEW
    private func setUpView() {
        
       
        
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let space = 0.05 * height
        let buttonHeight = 0.06 * height
        
        background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        mainMenuTitleLabel.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 3.5, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        mainMenuButton.anchor(top: mainMenuTitleLabel.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height:buttonHeight))
        importMenuButton.anchor(top: mainMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        newMenuButton.anchor(top: importMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
//        startOverMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        switchMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        cameraMenuButton.anchor(top: switchMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        logoutMenuButton.anchor(top: cameraMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        
        
        versionNumber.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.rightAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 35), size: .init(width: 75, height: 22))
        
       
        let frame = CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height)
        var c = CustomViewUpdate(frame: frame)
        changeCustomViewUpdate(customView: &c, value: 5, effect: .blur, constimage: nil, mainImgView: nil)
        c.isActive = false
        c.valueLabel.text = ""
        c.blur.layer.borderWidth = 0
    
        background.addSubview(c)
        
    }
    
 
    func backgroundChanged() {
        imageName = Globals.shared.getCurrentBackGround()
        if (imageName == "camera"){
            background.image = Globals.shared.getCameraImage()
        } else {
            let image = UIImage(named: imageName)
            background.image = image
        }
    }

}


extension MainMenuViewController : BackgroundChangeDelegate {
    func backgorundDidChange() {
        backgroundChanged()
    }
    
    
}
