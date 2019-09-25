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
import Reachability
import PopupDialog

protocol BackgroundChangeDelegate : class {
    func backgorundDidChange()
}

class BackgroundChangeController : UICollectionViewController, BackgroundChangeDelegate {
    
    weak var delegate : BackgroundChangeDelegate?
    
    func backgorundDidChange() {
        
    }
    
    
    var images = Globals.shared.backGrounds
    
    //let images = ["tes", "mainTes", "tes-1"]
    var pickerView = PickerView()
    var fileObject = importFile()
    var reach: Reachability!
    var currentSession: Session!
    let storage = LoaclStorage.init()
    var didChangeStatus = false
    lazy var localStorage = LoaclStorage.init()
    //this is to prevent the user to spam click buttons which will prevent multiple views from appearing and crashing the app
    // this is a sub optimal way of dealing with this.. a completion handler would be better
    var timer : Timer?
    var buttonHasBeenPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        //view.alpha = 0.5
        collectionView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        //collectionView?.backgroundColor.
        collectionView.register(ChangeCell.self, forCellWithReuseIdentifier: "cellID")
        fileObject.delegate = self
        pickerView.delegate = self

    }
    @objc func reset(){
        buttonHasBeenPressed = false
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ChangeCell
        if indexPath.item == images.count - 1 {
            
        }
         cell.imageAt = images[indexPath.item]
        return cell
    }
    
    func deleteImage(cell: Int){
        let imageBack = Globals.shared.backGrounds
        let image = imageBack[cell]

        storage.deleteBackgroundImage(image: image)
        if Globals.shared.backGrounds[cell].isImported == .imported {
            Globals.shared.backGrounds.remove(at: cell)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageName = images[indexPath.item].Backgroundimage!
        if !(indexPath.item == images.count - 1) {
           
                let title = "Are you sure you want to Logout?"
            
                let message = "This is a very important message about logging out and how it is good to do so when the app is no longer in use"
            
            //let image = UIImage(named: "pexels-photo-103290")
            
            let popup = PopupDialog(title: title, message: message, tapGestureDismissal: true, panGestureDismissal: false)
            // flag = true
            let buttonOne = CancelButton(title: "CANCEL", dismissOnTap: true) {
                
            }
            let buttonTwo = DefaultButton(title: "Use Photo", dismissOnTap: true) {
                let image = imageName
                Globals.shared.setCurrentBackGround(newBack: self.images[indexPath.item])
                if self.images[indexPath.item].title! == "camera"{
                    Globals.shared.cameraImage = self.images[indexPath.item].Backgroundimage
                }
                self.delegate?.backgorundDidChange()
                if self.didChangeStatus == true {
                    Globals.shared.importAndExportLoaction = .local
                }
                self.dismiss(animated: false,
                             completion: nil)
            }
            let buttonThree = DefaultButton(title: "delete Photo", dismissOnTap: true) {
                self.deleteImage(cell: indexPath.item)
            }
            popup.addButtons([buttonOne, buttonTwo, buttonThree])
            
            self.present(popup, animated: false, completion: nil)

        } else {
            if buttonHasBeenPressed == false {
            reach = Reachability.forInternetConnection()
            if reach!.isReachableViaWiFi() || reach!.isReachableViaWWAN() {
                
                fileObject.getFolderItems(withID: "0", completion: { (uploaded:Bool, error:Error?) in
                    if let fileError = error {
                        self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                        self.currentSession = Session(currentSubjectId: ("import"))
                        self.currentSession.boxAuthorize()
                    }
                    else {
            
                    }
                })
                if Globals.shared.importAndExportLoaction == .local {
                    Globals.shared.importAndExportLoaction = .box
                    self.didChangeStatus = true
                }
                pickerView = PickerView()
                
                pickerView.delegate = self
            }
        }
            buttonHasBeenPressed = true
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reset), userInfo: nil, repeats: true)
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    func getImportedData(boxitems: [BOXItem]){
    
        pickerView.twodimArray = processData(boxitems: boxitems)
        let nav = UINavigationController(rootViewController: pickerView)
        nav.modalPresentationStyle = .overCurrentContext
        
        //vc.twodimArray = twoDArray
        self.present(nav,animated: true, completion: nil)
    }
    //checks gets files from box and presents it
    func checkFilesToDownLoad(Files: [FilesToDownload]) {
        var currentData : [String]?
        if !Files.isEmpty{
            //let filename = Files.first?.name.components(separatedBy: "_")
            let file = Files.first
                let group = DispatchGroup()
                group.enter()
                
                let newfile = self.fileObject.downLoadFile(withId: file!.id, completion: { (uploaded:Bool, error:Error?) in
                    if let fileError = error {
                        self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                    }
                    else {
                        self.showToast(message: "\(file!.name) has Successfully been downloaded", theme: .success)
                        group.leave()
                    }
                })
                group.notify(queue: .main) {
                    do{
                        //UIImage(data: newfile)
                        if let data = try? Data(contentsOf: newfile) {
                            let image = UIImage(data: data)
                            //ADD CHECKS HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                            if !(image == nil){
                            let temp = BackgroundImage()
                                temp.Backgroundimage = image
                                temp.ID = Int(file!.id)
                                temp.title = file?.name
                                temp.isImported = .imported
                            Globals.shared.currentBackGround = temp
                            Globals.shared.cameraImage = temp.Backgroundimage
                                Globals.shared.backGrounds.insert(temp, at: Globals.shared.backGrounds.count - 1)
                            self.storage.SaveImageToLocal(name: file!.name, title: file!.name, id: 0, image: data)
                            PersistanceService.save()
                            self.delegate?.backgorundDidChange()
                            } else {
                                self.showToast(message: "Did not load Data from \(file!.name), Incorrect: FileType/Data", theme: .error)
                            }
                            if self.didChangeStatus == true {
                                Globals.shared.importAndExportLoaction = .local
                            }
                            self.dismiss(animated: false, completion: nil)
                        }
                    } catch {
                        self.showToast(message: "Did not load Data from \(file!.name), Incorrect: FileType/Data", theme: .error)
                    }
                   
                }
                
            }
        }
    //}
    
}

extension BackgroundChangeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: view.frame.height / 2)
    }
}
extension BackgroundChangeController: ImportDelegate{
    func didReceiveData(boxItems: [BOXItem]) {
        getImportedData(boxitems: boxItems)
    }
    func FileInfoReceived(){
        
    }
}
extension BackgroundChangeController: PickerViewdelegate{
    func getFilestoDownload(files: [FilesToDownload]) {
        checkFilesToDownLoad(Files: files)
}
}
