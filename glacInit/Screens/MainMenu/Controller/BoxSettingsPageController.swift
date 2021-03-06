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

import Foundation
import UIKit
import PopupDialog
import Reachability

class BoxSettingsPage: UIViewController {
    
//    var loginMenuButton : UIButton = {
//        var temp = UIButton(type: .system)
//        setUpButton(&temp, title: "Login", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
//        temp.isOpaque = false
//        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
//        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
//        temp.setTitleColor(.white, for: .normal)
//        temp.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
//        return temp
//    }()
    
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
        let image = Globals.shared.getCurrentBackGround()
        temp.image = image.Backgroundimage
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
        [background, backMenuButton, exportFolderMenuButton, logoutMenuButton].forEach {view.addSubview($0)}
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
        
        //loginMenuButton.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 6, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height:buttonHeight))
        logoutMenuButton.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 7, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        exportFolderMenuButton.anchor(top: logoutMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        backMenuButton.anchor(top: exportFolderMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
  
        let frame = CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height)
        var c = CustomViewUpdate(frame: frame)
        changeCustomViewUpdate(customView: &c, value: 5, effect: .blur, constimage: nil, mainImgView: nil)
        c.isActive = false
        c.colorValueLabel.text = ""
        c.blur.layer.borderWidth = 0
        
        background.addSubview(c)
    }
    
    func backgroundChanged() {
        imageName = Globals.shared.getCurrentBackGround()
        if (imageName.title == "camera"){
            background.image = Globals.shared.getCameraImage()
        } else {
            let image = imageName.Backgroundimage
            background.image = image
        }
    }
    
//    @objc func loginTapped() {
//        reach = Reachability.forInternetConnection()
//        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
//            self.currentSession = Session(currentSubjectId: ("import"))
//            self.currentSession.boxAuthorize()
//            Globals.shared.importAndExportLoaction = .box
//        }
//    }
    @objc func logoutTapped() {
        let title = "Are you sure you want to Logout?"
        let message = "If you are not logged in, Go to a New Session/Import and it will prompt a login"
        let popup = PopupDialog(title: title, message: message, tapGestureDismissal: true, panGestureDismissal: false)
        let buttonOne = CancelButton(title: "CANCEL", dismissOnTap: true) {
        }
        let buttonTwo = DefaultButton(title: "BOX LOGOUT", dismissOnTap: true) {
            BOXContentClient.logOutAll()
            Globals.shared.importAndExportLoaction = .local
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
      
        pickerView.twodimArray = processData(boxitems: boxitems)
        let nav = UINavigationController(rootViewController: pickerView)
        nav.modalPresentationStyle = .overCurrentContext

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
