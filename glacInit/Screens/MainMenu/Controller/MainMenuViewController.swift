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
/*
 * MainMenuViewController -
 * This presents the user between choices
 * All the menus are in the same folder because none of them really use models or views
 * pretty much just a viewController with buch of buttons that will present other views
 */
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
        nonEditableTextView(&temp, text: "-v 2.5.4", fontSize: 15)
        temp.textColor = .black
        temp.backgroundColor = .clear
        temp.textAlignment = .center
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
//    var switchMenuButton : UIButton = {
//        var temp = UIButton(type: .system)
//
//        setUpButton(&temp, title: "switch", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
//        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
//        temp.isOpaque = false
//        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
//        temp.setTitleColor(.white, for: .normal)
//        temp.addTarget(self, action: #selector(switchMenuButtonTapped), for: .touchUpInside)
//        return temp
//    }()
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
    
    var saveLocationButton : UIButton = {
        var temp = UIButton(type: .system)
        
        setUpButton(&temp, title: "Export Settings", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(chooseLocationToSave), for: .touchUpInside)
        return temp
    }()
    
    var background : UIImageView = {
        var temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        let image = Globals.shared.currentBackGround
        temp.image = image.Backgroundimage
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
        [background, mainMenuButton, importMenuButton, newMenuButton, logoutMenuButton, versionNumber, saveLocationButton, cameraMenuButton].forEach {view.addSubview($0)}
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
//    @objc func switchMenuButtonTapped(_sender: UIButton){
//        self.parent?.dismiss(animated: true, completion: nil)
//        let layout = UICollectionViewFlowLayout()
//        let vc = BackgroundChangeController(collectionViewLayout: layout)
//        vc.delegate = self
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true, completion: nil)
//    }
   
    @objc func BoxSettingsTapped(){
        let vc = BoxSettingsPage()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @objc func cameraMenuButtonTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.originalImage] as? UIImage)
        background.image = image
        Globals.shared.setCameraImage(image: image!)
        let temp = BackgroundImage()
        temp.Backgroundimage = nil
        temp.ID = 1
        temp.title = "camera"

        Globals.shared.setCurrentBackGround(newBack: temp)
        updateBackground(image: image!)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func updateBackground(image: UIImage){
            background.image = image
    }
    @objc func chooseLocationToSave() {
        let vc = LocationToSaveFilesController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
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
        
       // mainMenuTitleLabel.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 2, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        mainMenuButton.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 4.5, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height:buttonHeight))
        importMenuButton.anchor(top: mainMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        newMenuButton.anchor(top: importMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        //switchMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        cameraMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        logoutMenuButton.anchor(top: cameraMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        saveLocationButton.anchor(top: logoutMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        
        
        versionNumber.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.rightAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 35), size: .init(width: 75, height: 22))
        
        let frame = CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height)
        var c = CustomViewUpdate(frame: frame)
        changeCustomViewUpdate(customView: &c, value: 5, effect: .blur, constimage: nil, mainImgView: nil)
        c.isActive = false
        c.colorValueLabel.text = ""
        c.greyValueLabel.isHidden = true
        c.blurValueLabel.isHidden = true
        c.blur.layer.borderWidth = 0
    
        background.addSubview(c)
        
    }
    func backgroundChanged() {
        imageName = Globals.shared.getCurrentBackGround()
        if (imageName.title == "camera"){
            background.image = Globals.shared.getCameraImage()
        } else {
            
            background.image = imageName.Backgroundimage
        }
    }

}
extension MainMenuViewController : BackgroundChangeDelegate {
    func backgorundDidChange() {
        backgroundChanged()
    }
    
    
}
