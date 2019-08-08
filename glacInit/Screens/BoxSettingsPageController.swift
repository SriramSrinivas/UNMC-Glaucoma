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

class BoxSettingsPage: UIViewController {
    
    var mainMenuTitleLabel : UIButton = {
        var temp = UIButton(type: .system)
        //temp.isOpaque = false
        //temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
        setUpButton(&temp, title: "Box Settings", cornerRadius: 0, borderWidth: 0, color: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5).cgColor)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.setTitleColor(.white, for: .normal)
        //temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        
        temp.isEnabled = false
        return temp
    }()
    
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
            
            file.getFolderItems(withID: "0", completion: { (uploaded:Bool, error:Error?) in
                if let fileError = error {
                    self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                    self.currentSession = Session(currentSubjectId: ("import"))
                    self.currentSession.boxAuthorize()
                }
                else {
                    
                }
            })
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
        
        self.present(popup, animated: true, completion: nil)
        // delegate!.getFilestoDownload(files: files)
    }
    
    @objc func exportFolderTapped() {
        
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
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




