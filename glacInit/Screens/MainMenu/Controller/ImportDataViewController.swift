//
//  ImportDataViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/9/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit
import Reachability

class ImportDataViewController: UIViewController {
    
    var mainMenuTitleLabel : UIButton = {
        var temp = UIButton(type: .system)
        //temp.isOpaque = false
        //temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5)
        setUpButton(&temp, title: "Choose Import Type", cornerRadius: 0, borderWidth: 0, color: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.5).cgColor)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.setTitleColor(.red, for: .normal)
        //temp.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        
        temp.isEnabled = false
        return temp
    }()
    
    var ContinueFromSavedButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "Continue From Saved", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(continueFormSavedTapped), for: .touchUpInside)
        return temp
    }()
    
    var ViewDataButton : UIButton = {
        var temp = UIButton(type: .system)
        setUpButton(&temp, title: "View Data", cornerRadius: 0, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.titleLabel?.font = UIFont(name: "Futura", size: 22)
        temp.isOpaque = false
        temp.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.65)
        temp.setTitleColor(.white, for: .normal)
        temp.addTarget(self, action: #selector(viewDataTapped), for: .touchUpInside)
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
    var currentLocalData : [LocalFileModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        file.delegate = self
        backgroundChanged()
        [background, mainMenuTitleLabel, ContinueFromSavedButton, ViewDataButton, backMenuButton].forEach {view.addSubview($0)}
        layout()
    }

    private func layout() {
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let space = 0.05 * height
        let buttonHeight = 0.06 * height
        
        background.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        mainMenuTitleLabel.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space * 3.5, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        ContinueFromSavedButton.anchor(top: mainMenuTitleLabel.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height:buttonHeight))
        ViewDataButton.anchor(top: ContinueFromSavedButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        backMenuButton.anchor(top: ViewDataButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        //        startOverMenuButton.anchor(top: newMenuButton.bottomAnchor, leading: view.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: space, left: 0.33 * width, bottom: 0, right: 0), size: .init(width: 0.33 * width, height: buttonHeight))
        
        
        let frame = CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height)
        var c = CustomViewUpdate(frame: frame)
        changeCustomViewUpdate(customView: &c, value: 5, effect: .blur, constimage: nil, mainImgView: nil)
        c.isActive = false
        c.valueLabel.text = ""
        c.blur.layer.borderWidth = 0
        
        background.addSubview(c)
    }
    //checks of background is camera image or not and displays it correctly
    func backgroundChanged() {
        imageName = Globals.shared.getCurrentBackGround()
        if (imageName == "camera"){
            background.image = Globals.shared.getCameraImage()
        } else {
            let image = UIImage(named: imageName)
            background.image = image
        }
    }
    
    @objc func viewDataTapped() {
        let vc = LoadedImageViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    //checks for interent connection
    // diplays pickerview at box root level
    @objc func continueFormSavedTapped() {
        if (Globals.shared.importAndExportLoaction == dataSource.box) {
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
            
            pickerView.delegate = self
        }
        } else {
            currentSession = Session(currentSubjectId: "hello")
            var hello : [LocalFileModel] = []
            do {
                try hello = currentSession.loadData()
            } catch {
                showToast(message: "Error In loading Data", theme: .error)
                hello = currentSession.getDataThatDidLoad()
            }
            currentLocalData = hello
            var twoDArray : [ExpandableNames] = []
            var fileItems: [BoxItemsData] = []
            var folderItems: [BoxItemsData] = []
            var count = 0;
            for items in hello {
                let changedata = BoxItemsData(name: items.name!, id: String(count))
                count = count + 1
                fileItems.append(changedata)
            }
            //let newArray = ExpandableNames(isExpanded: true, items: folderItems!)
            folderItems = fileItems
            twoDArray.append(ExpandableNames(isExpanded: true, items: folderItems))
            twoDArray.append(ExpandableNames(isExpanded: true, items: fileItems))
            
            pickerView.twodimArray = twoDArray
            pickerView.Source = dataSource.local
            let nav = UINavigationController(rootViewController: pickerView)
            nav.modalPresentationStyle = .overCurrentContext
            
            //vc.twodimArray = twoDArray
            self.present(nav,animated: true, completion: nil)
        }
        
    }
    @objc func backTapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func checkFilesToDownLoad(Files: [FilesToDownload]){
        if (Globals.shared.importAndExportLoaction == dataSource.box) {
        var currentData : [String]?
        if !Files.isEmpty{
            let filename = Files.first?.name.components(separatedBy: "_")
            let file = Files.first
            //if file?.name.contains("saveFile"){
            
            if checkForFileName(fileName: filename!){
                // self.dismiss(animated: true, completion: nil)
                let group = DispatchGroup()
                group.enter()
                
                let newfile = self.file.downLoadFile(withId: file!.id, completion: { (uploaded:Bool, error:Error?) in
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
                        var content = String()
                        content = try String.init(contentsOf: newfile, encoding: .utf8)
                        let data = self.cleanRows(file: content)
                        currentData = self.csv(data: data)
                    } catch {
                        self.showToast(message: "Did not load Data from \(file!.name), Incorrect: FileType/Data", theme: .error)
                    }
                    let vc = ViewController()
                    let backgrounds = self.checkForBackGround(name: filename!)
                    //Globals.shared.setCurrentBackGround(newBack: background)
                    vc.backImageName = backgrounds
                    self.present(vc, animated: true, completion: nil)
                    vc.subjectID = filename?.first ?? ""
                    vc.addWaterMark(name: filename?.first ?? "")
                    vc.currentSession = Session(currentSubjectId: vc.subjectID)
                    vc.nameLabel.textAlignment = .center
                    vc.nameLabel.center.x = vc.nameLabel.frame.maxX
                    vc.loadDatafromFile(linesOfData: currentData!)
                }
                
            }
        }
        } else {
            let id = Int(Files.first!.id)!
            let filename = Files.first?.name.components(separatedBy: "_")
            let filesToLoad = currentLocalData![id]
            do{
                //filesToLoad.blurdata
                let currentData = self.csv(data: filesToLoad.savedata!)
                //if (checksDataForErrors(newData: currentData) ){
                let vc = ViewController()
                let backgrounds = self.checkForBackGround(name: filename!)
                //Globals.shared.setCurrentBackGround(newBack: background)
                vc.backImageName = backgrounds
                self.dismiss(animated: false, completion: nil)
                self.present(vc, animated: true, completion: nil)
                vc.subjectID = filename?.first ?? ""
                vc.addWaterMark(name: filename?.first ?? "")
                vc.currentSession = Session(currentSubjectId: vc.subjectID)
                vc.nameLabel.textAlignment = .center
                vc.nameLabel.center.x = vc.nameLabel.frame.maxX
                vc.loadDatafromFile(linesOfData: currentData)
                
        }
        }
        
    }
    func checkForBackGround(name: [String]) -> String{
        for word in name{
            for back in Globals.shared.backGrounds{
                if word == back
                {
                    return word
                }
            }
        }
        return "mainTes"
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
    func csv(data: String) -> [String] {
        var result: [String]?
        result = data.components(separatedBy: "\n")
        //        for row in rows {
        //            let columns = row.components(separatedBy: ",")
        //            result.append(columns)
        //        }
        return result!
    }
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func checkForFileName(fileName: [String]) -> Bool {
        for word in fileName {
            if word == "saveFile" {
                return true
            }
        }
        return false
    }
    
}
extension ImportDataViewController : PickerViewdelegate{
    func getFilestoDownload(files: [FilesToDownload]) {
        checkFilesToDownLoad(Files: files)
    }
    
    
}
extension ImportDataViewController : ImportDelegate{
    func didReceiveData(boxItems: [BOXItem]) {
        getImportedData(boxitems: boxItems)
    }
    func FileInfoReceived(){
        
    }
}
