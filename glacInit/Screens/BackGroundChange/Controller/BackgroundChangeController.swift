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

protocol BackgroundChangeDelegate : class {
    func backgorundDidChange()
}

class BackgroundChangeController : UICollectionViewController, BackgroundChangeDelegate {
    
    weak var delegate : BackgroundChangeDelegate?
    
    func backgorundDidChange() {
        
    }
    
    
    var images: [BackgroundImage] = {
        var temp = BackgroundImage()
        temp.BackgroundimageName = "tes"
        temp.ID = 21
        temp.title = "Rocket League"
        
        var temp1 = BackgroundImage()
        temp1.BackgroundimageName = "tes-1"
        temp1.ID = 3
        temp1.title = "Forest"

        var temp2 = BackgroundImage()
        temp2.BackgroundimageName = "mainTes"
        temp2.ID = 2
        temp2.title = "city"
        
        var temp3 = BackgroundImage()
        temp3.BackgroundimageName = "plus"
        temp3.ID = 4
        temp3.title = "plus1"
        return [temp, temp1, temp2, temp3]
   //     return [temp]
    }()
    
    //let images = ["tes", "mainTes", "tes-1"]
    var pickerView = PickerView()
    var fileObject = importFile()
    var reach: Reachability!
    var currentSession: Session!
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageName = images[indexPath.item].BackgroundimageName!
        if !(indexPath.item == images.count - 1) {
        let image = UIImage(named: imageName)
        Globals.shared.setCurrentBackGround(newBack: imageName)
        delegate?.backgorundDidChange()
        
//        let viewController = MainMenuViewController()
//        self.present(viewController, animated: true, completion: nil)
        self.dismiss(animated: false,
                     completion: nil)
        } else {
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
                pickerView = PickerView()
                
                pickerView.delegate = self
            }
        }
        //self.dismiss(animated: true, completion: nil)
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
    func checkFilesToDownLoad(Files: [FilesToDownload]) {
        var currentData : [String]?
        if !Files.isEmpty{
            //let filename = Files.first?.name.components(separatedBy: "_")
            let file = Files.first
            //if file?.name.contains("saveFile"){
            
            //if checkForFileName(fileName: filename!){
                // self.dismiss(animated: true, completion: nil)
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
                            Globals.shared.currentBackGround = "camera"
                            Globals.shared.cameraImage = image
                            self.delegate?.backgorundDidChange()
                            self.dismiss(animated: false, completion: nil)
                        //conte
                       // let data = self.cleanRows(file: content)
                       // currentData = self.csv(data: data)
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
