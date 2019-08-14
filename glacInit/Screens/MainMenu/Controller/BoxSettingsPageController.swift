//
//  BoxSettingsPageController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/8/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog
import Reachability

class BoxSettingsPage: UIViewController {
    
//    var mainMenuTitleLabel : UIButton = {
//        var temp = UIButton(type: .system)
//        //temp.isOpaque = false
//        //temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
//        setUpButton(&temp, title: "Box Settings", cornerRadius: 0, borderWidth: 0, color: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5).cgColor)
//        temp.isOpaque = false
//        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
//        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
//        temp.setTitleColor(.red, for: .normal)
//        //temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
//
//        temp.isEnabled = false
//        return temp
//    }()
    
    var loginMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Login", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return temp
    }()
    
    var logoutMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Logout", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return temp
    }()
    
    var exportFolderMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Export Folder", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.tag = 1
        temp.addTarget(self, action: #selector(exportFolderTapped), for: .touchUpInside)
        return temp
    }()
    
    var backMenuButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Back", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return temp
    }()
    var background : UIImageView = {
        var temp = UIImageView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = UIImage(named: Globals.shared.getCurrentBackGround())
        return temp
    }()
    
    var pickerView = PickerView()
    let file = importFile.init()
    var imageName = Globals.shared.getCurrentBackGround()
    var reach: Reachability!
    var currentSession: Session!
    //MARK: VIEW MANAGEMENT
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        pickerView.delegate = self
        file.delegate = self
        backgroundChanged()
        [background, backMenuButton, exportFolderMenuButton, logoutMenuButton, loginMenuButton].forEach {view.addSubview($0)}
        layout()
    }
    
    func layout() {
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let space = 0.05 * height
        let buttonHeight = 0.06 * height
        
        background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        //mainMenuTitleLabel.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 3.5, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        loginMenuButton.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 6, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height:buttonHeight))
        logoutMenuButton.anchor(top: loginMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        exportFolderMenuButton.anchor(top: logoutMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        //        startOverMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        backMenuButton.anchor(top: exportFolderMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
  
    
        
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
    
    @objc func loginTapped() {
        reach = Reachability.forInternetConnection()
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            
           
                    self.currentSession = Session(currentSubjectId: ("import"))
                    self.currentSession.boxAuthorize()
            
    }
    }
    @objc func logoutTapped() {
        var title = "Are you sure you want to Logout?"
        
        var message = "This is a very important message about logging out and how it is good to do so when the app is no longer in use"
        
        //let image = UIImage(named: "pexels-photo-103290")
        
        let popup = PopupDialog(title: title, message: message, tapGestureDismissal: true, panGestureDismissal: false)
        // flag = true
        let buttonOne = CancelButton(title: "CANCEL", dismissOnTap: true) {
            
        }
        let buttonTwo = DefaultButton(title: "BOX LOGOUT", dismissOnTap: true) {
            BOXContentClient.logOutAll()
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        
        self.present(popup, animated: false, completion: nil)
        // delegate!.getFilestoDownload(files: files)
    }
    
    @objc func exportFolderTapped(_ sender: UIButton) {
        reach = Reachability.forInternetConnection()
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            
            file.getFolderItems(withID: "0", completion: { (uploaded:Bool, error:Error?) in
                if let fileError = error {
                    self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                    self.currentSession = Session(currentSubjectId: ("import"))
                    self.currentSession.boxAuthorize()
                }
                else {
                    
                }
            })
            pickerView = PickerView()
            if sender.tag == 1{
                pickerView.checkingForFiles = false
            }
            pickerView.delegate = self
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func checkFilesToDownLoad(Files: [FilesToDownload]){
        if Files.first?.isFolder ?? false {
            Globals.shared.currentFolderExport = Files.first!.id
        }
        
    }
    
    func getImportedData(boxitems: [BOXItem]){
        //let vc = PickerView()
        var twoDArray : [ExpandableNames] = []
        var fileItems: [BoxItemsData] = []
        var folderItems: [BoxItemsData] = []
        for items in boxitems {
            let changedata = BoxItemsData(boxItem: items)
            if changedata.isFolder {
                folderItems.append(changedata)
            } else {
                fileItems.append(changedata)
            }
        }
        //let newArray = ExpandableNames(isExpanded: true, items: folderItems!)
        twoDArray.append(ExpandableNames(isExpanded: true, items: folderItems))
        twoDArray.append(ExpandableNames(isExpanded: true, items: fileItems))
        
        pickerView.twodimArray = twoDArray
        let nav = UINavigationController(rootViewController: pickerView)
        nav.modalPresentationStyle = .overCurrentContext
        
        //vc.twodimArray = twoDArray
        self.present(nav,animated: true, completion: nil)
    }

}
extension BoxSettingsPage : PickerViewdelegate{
    func getFilestoDownload(files: [FilesToDownload]) {
        checkFilesToDownLoad(Files: files)
    }
    
    
}
extension BoxSettingsPage : ImportDelegate{
    func didReceiveData(boxItems: [BOXItem]) {
        getImportedData(boxitems: boxItems)
    }
    func FileInfoReceived(){
        
    }
}
