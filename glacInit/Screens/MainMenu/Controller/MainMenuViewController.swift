//
//  MainMenuViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/31/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: CLASS VARIABLES
    var imagePicker: UIImagePickerController!

    var mainMenuTitleLabel : UIButton = {
        var temp = UIButton(type: .system)
        let image = UIImage(named: "redImage")
        temp.setBackgroundImage(image, for: .normal)
        setUpButton(&temp, title: "Menu", cornerRadius: 0, borderWidth: 0, color: "")
        temp.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 30)
        temp.titleLabel?.textColor = .white
        temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        
        temp.isEnabled = false
        return temp
    }()
    
    var mainMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        let image = UIImage(named: "greyImage")
        temp.setBackgroundImage(image, for: .normal)
        //temp.setImage(image, for: .normal)
        temp.titleLabel?.text = "Back"
        setUpButton(&temp, title: "Back to Previous", cornerRadius: 0, borderWidth: 5, color: "")
        temp.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 30)
        temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        return temp
    }()
    
    var importMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        let image = UIImage(named: "greyImage")
        temp.setBackgroundImage(image, for: .normal)
        setUpButton(&temp, title: "Import", cornerRadius: 0, borderWidth: 5, color: "")
        temp.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 30)
        temp.addTarget(self, action: #selector(importMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
    
    var newMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        let image = UIImage(named: "greyImage")
        temp.setBackgroundImage(image, for: .normal)
        setUpButton(&temp, title: "New Session", cornerRadius: 0, borderWidth: 5, color: "")
        temp.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 30)
        temp.addTarget(self, action: #selector(newMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
    // difference between new and this, is that new will ask for a new subject ID whereas this
    // will continue with last subject ID
//    var startOverMenuButton : UIButton = {
//        var temp = UIButton(type: .system)
//        let image = UIImage(named: "Start over")
//        setUpButton(&temp, title: "Start over", cornerRadius: 25, borderWidth: 0, color: "")
//        temp.setImage(image, for: .normal)
//        temp.backgroundColor = .red
//        temp.addTarget(self, action: #selector(startOverMenuButtonTapped), for: .touchUpInside)
//        return temp
//    }()
    
    var switchMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        let image = UIImage(named: "greyImage")
         temp.setBackgroundImage(image, for: .normal)
//        temp.imageView?.image = image
//        temp.imageView?.clipsToBounds = true
//        temp.imageView?.contentMode = .scaleAspectFit

        setUpButton(&temp, title: "switch", cornerRadius: 0, borderWidth: 5, color: "")
        temp.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 30)
        //temp.setImage(image, for: .normal)
        //temp.setBackgroundImage(image, for: .normal)
        //temp.backgroundColor = .red
        temp.addTarget(self, action: #selector(switchMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
    var cameraMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        let image = UIImage(named: "greyImage")
        temp.setBackgroundImage(image, for: .normal)
        setUpButton(&temp, title: "Camera", cornerRadius: 0, borderWidth: 5, color: "")
        temp.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 30)
        temp.addTarget(self, action: #selector(cameraMenuButtonTapped), for: .touchUpInside)
        return temp
    }()
    
    var background : UIImageView = {
        var temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: Globals.shared.getCurrentBackGround())
        return temp
    }()
    
    var imageName = Globals.shared.getCurrentBackGround()
    
    //MARK: VIEW MANAGEMENT
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if (imageName == "camera"){
            background.image = Globals.shared.getCameraImage()
        } else {
            let image = UIImage(named: imageName)
            background.image = image
        }
    
        navigationController?.navigationBar.isHidden = true
        [background, mainMenuButton, mainMenuTitleLabel, importMenuButton, newMenuButton, switchMenuButton, cameraMenuButton].forEach {view.addSubview($0)}
        setUpView()
    }
    override func viewDidAppear(_ animated: Bool) {
        if (imageName == "camera"){
            background.image = Globals.shared.getCameraImage()
        } else {
            let image = UIImage(named: imageName)
            background.image = image
        }
    }
    //MARK: BUTTON ACTIONS
    
    @objc func MenuTapped(_sender: UIButton){
       self.dismiss(animated: true, completion: nil)
    }
    @objc func importMenuButtonTapped(_sender: UIButton){
        let vc = LoadedImageViewController()
        self.present(vc, animated: true, completion: nil)
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
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    enum ImageSource {
        case photoLibrary
        case camera
    }

    @objc func cameraMenuButtonTapped(){
       
    }
   

    
    //MARK: SETUPVIEW
    private func setUpView() {
        
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let space = 0.05 * height
        let buttonHeight = 0.09 * height
        
        background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        mainMenuTitleLabel.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        mainMenuButton.anchor(top: mainMenuTitleLabel.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height:buttonHeight))
        importMenuButton.anchor(top: mainMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        newMenuButton.anchor(top: importMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
//        startOverMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        switchMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        cameraMenuButton.anchor(top: switchMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
    }
    
    
}
