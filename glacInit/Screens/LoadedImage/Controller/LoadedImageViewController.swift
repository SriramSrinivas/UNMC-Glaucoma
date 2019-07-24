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
// Add a button for importing files
// imports need to have an exact name to query



//import SwiftUI
import Foundation
import UIKit
import CoreImage
import CoreGraphics
import NotificationCenter

//protocol PickerViewdelegate: class {
//    func getFilestoDownload(files: [FilesToDownload])
//}


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
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(grewSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()

    var blackSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(blackSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var colorSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(colorSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var isHiddenSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(isHiddenSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var allSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(allSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    var gridSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(toggleGrid(mySwitch:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var blurLabel : UIImageView = {
        let image = UIImage(named: "BlurOn")
       var temp = UIImageView.init(image: image)
        return temp
    }()
    
    var illumLabel : UIImageView = {
        let image = UIImage(named: "lumin")
        var temp = UIImageView.init(image: image)
        return temp
    }()
    
    var colorLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Color", fontSize: 15)
        return temp
    }()
    
    var IsHiddenLabel : UIImageView = {
        let image = UIImage(named: "SightOn")
        var temp = UIImageView.init(image: image)
        return temp
    }()
    
    var allLabel : UITextView = {
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
        setUpButton(&temp, title: "Back", cornerRadius: 10, borderWidth: 0, color: "red")
        temp.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        return temp
    }()
    var importButton : UIButton = {
        var temp = UIButton()
        setUpButton(&temp, title: "Import", cornerRadius: 10, borderWidth: 0, color: "red")
        temp.addTarget(self, action: #selector(getNewFile), for: .touchUpInside)
        return temp
    }()
    
    
    var backGroundImages = ["mainTes", "tes-1"]
    var greyCustomViewUpdateList = [CustomViewUpdate]()
    var blurCustomViewUpdateList = [CustomViewUpdate]()
    var colorCustomViewUpdateList = [CustomViewUpdate]()
    var objectCustomViewUpdateList = [CustomViewUpdate]()
    //fileTypes blur = 1, grey = 2. color = 3 hidden = 4
    var constImage = UIImage(named: "mainTes")
    let file = importFile.init()
    var pickerView = PickerView()
    
    var gridViews = [UIView]()
    let distances =  [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        file.delegate = self
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .red

        //NotificationCenter.default.addObserver(file, selector: #selector(getImportedData), name: NSNotification.Name("Getting Data"), object: nil)
        [sideImageView, mainImageView, blurLabel, blurSwitch, illumLabel, blackSwitch, colorLabel, colorSwitch, IsHiddenLabel, allSwitch, allLabel, isHiddenSwitch, gridLabel, gridSwitch, backButton, importButton].forEach {view.addSubview($0)}
        initCustomObjects(h: 0, w: 0)
        //checkAountOfFilesDownlaodinf()
        setUpView()
       // file.getFolderItems(withID: "0")
        addGridLineUpdate(mainView: mainImageView)
    }
    
    func importFilesssss(){
        
    }
  
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = width  / size.width
        let heightRatio = height / size.height
        
        var newSize: CGSize
        
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * heightRatio)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }
  //fileTypes blur = 1, grey = 2. color = 3 hidden = 4
    func addblur(currentFileType: Int, currentData: [[String]]){
        let midx = ((view.frame.width/5)*4)/2
        let midy = view.frame.height/2
        let width = (view.frame.width/5)*4
        let height = view.frame.height
        var countx = 1
        var county = 1
        constImage = resizeImage(image: constImage!, width: width, height: height + 1)
        
        for number in distances {
            for numb in distances {
                
                let x = ((numb/2) * Double(height) + Double(midy))
                let y = ((number/2) * Double(width) + Double(midx))
                _ = (numb.nextUp * Double(width) + Double(midx))/2 - x
                let frame = CGRect(x: y, y:x, width: 15, height: 15)

                let value = currentData[countx][county]
                let a:Int? = Int(value)
                if (currentFileType == 1 && value != "0"){
                    let c = CustomViewUpdate(frame: frame)
                    
                    c.isActive = false
                    c.blur.layer.borderWidth = 1
                    c.layer.zPosition = 2
                    c.blur.blurRadius = CGFloat(a!/10)
                    c.isActive = false
                    c.includesEffect()
                    blurCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                if (currentFileType == 2 && value != "0"){
                    let c = CustomViewUpdate(frame: frame)
                    c.layer.zPosition = 2
                    c.isActive = false
                    c.layer.borderWidth = 1
                    c.layer.borderColor = UIColor.red.cgColor
                    c.blur.backgroundColor = UIColor.black
                    c.blur.alpha = CGFloat(a!/10)
                    c.blur.blurRadius = 0
                    greyCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
               if (currentFileType == 3 && value != "0"){
                    let c = CustomViewUpdate(frame: frame)
                    var cropImage = constImage
                    c.setImageConst(images: constImage!)
                    c.blur.layer.borderWidth = 1

                    cropImage = cropImage!.crop(rect: c.frame)
                    cropImage = cropImage?.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(a!/10)), blendMode: .luminosity)
                
                    if ((cropImage) != nil){
                        c.addImage(images: cropImage!)
                    }
                    
                    c.blur.backgroundColor = nil
                    colorCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                if (currentFileType == 3 && value != "0"){
                    let c = CustomViewUpdate(frame: frame)
                    c.layer.zPosition = 2
                    c.isActive = false
                    c.layer.borderWidth = 6
                    c.layer.borderColor = UIColor.red.cgColor
                    c.blur.backgroundColor = UIColor.black
                    c.blur.alpha = CGFloat(a!/10)
                    c.blur.blurRadius = 0
                    greyCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                countx = countx + 1
            }
            county = county + 1
            countx = 1
        }
    }
    //will need some sort of local storage for it most likely
    // give the file path.. this should work for any of the files (color, grey and blur)
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    private func setUpView(){
        
        mainImageView.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .zero, size: .init(width: view.frame.width - view.frame.width/5, height: view.frame.height))
        sideImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.rightAnchor, padding: .zero, size: .init(width: view.frame.width/5, height: view.frame.height))
        //blurLabel.anchor(top: sideImageView.topAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        blurLabel.frame = CGRect(x: view.bounds.size.width - 140, y: 40, width: 50, height: 50)
        blurSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 100, width: 100, height: 50)
        
        //illumLabel.anchor(top: blurLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        illumLabel.frame = CGRect(x: view.bounds.size.width - 140, y: 140, width: 50, height: 50)
        blackSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 200, width: 100, height: 50)
        colorLabel.anchor(top: illumLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        colorSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 300, width: 100, height: 50)
        
        //IsHiddenLabel.anchor(top: colorLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        IsHiddenLabel.frame = CGRect(x: view.bounds.size.width - 140, y: 340, width: 50, height: 50)
        isHiddenSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 400, width: 100, height: 50)
         allLabel.anchor(top: IsHiddenLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        allSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 470, width: 100, height: 50)
        
        gridLabel.anchor(top: allLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        gridSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 545, width: 100, height: 50)
        backButton.anchor(top: gridSwitch.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 50))
        importButton.anchor(top: backButton.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 50))
    }
    
    func initCustomObjects(h:CGFloat, w:CGFloat){
        
        customObjectList = createobjects(pictureID: 1, height: 0, width: 0)
        
        for i in customObjectList {
            i.isUserInteractionEnabled = true
          
            mainImageView.addSubview(i)
            mainImageView.bringSubviewToFront(i)
        }
    }
    
    func addGridLineUpdate(mainView: UIView){
        
        let width = (view.frame.width/5)*4
        let height = view.frame.height
        
        let line1 = UIButton()
        line1.frame = CGRect(x: width*0.3, y: 0, width: 5, height: height)
        line1.layer.borderWidth = 5
        line1.layer.borderColor = UIColor(hexString: "FF9800").cgColor
        
        let line2 = UIButton()
        line2.frame = CGRect(x: width*0.66, y: 0, width: 5, height: height)
        line2.layer.borderWidth = 5
        line2.layer.borderColor = UIColor(hexString: "FF9800").cgColor
        
        let line3 = UIButton()
        line3.frame = CGRect(x: 0, y: height*0.5, width: width, height: 5)
        line3.layer.borderWidth = 5
        line3.layer.borderColor = UIColor(hexString: "FF9800").cgColor
        
        gridViews.append(line1)
        gridViews.append(line2)
        gridViews.append(line3)
        
        for i in gridViews {
            
            mainImageView.insertSubview(i, aboveSubview: mainImageView)
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
    @objc func toggleGrid(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        switch (value) {
        case false:
            for i in gridViews {
                i.isHidden = true
                
            }
        case true:
            for i in gridViews {
                i.isHidden = false
               
                }
            }
        }
    @objc func backButtonPressed(sender: UIButton){
        let vc = ViewController()
        self.present(vc,animated: true, completion: nil)
    }
    
    @objc func getNewFile(){
        greyCustomViewUpdateList.removeAll()
        blurCustomViewUpdateList.removeAll()
        colorCustomViewUpdateList.removeAll()
        objectCustomViewUpdateList.removeAll()
        file.getFolderItems(withID: "0")
        pickerView = PickerView()
        pickerView.delegate = self
    }
    //name then id
    func checkFilesToDownLoad(Files: [FilesToDownload]){
        if Files.isEmpty{
            //do nothing
        }
        else{
            for file in Files {
                let names = file.name.components(separatedBy: "_")
                
                
                let back = checkForBackGround(name: names)
                mainImageView.image = UIImage(named: back)
                mainImageView.reloadInputViews()
                //if returns 0 it failed
                let fileIntValue = checkForKindOfFile(name: names)
                
                
                let newfile = self.file.downLoadFile(withId: file.id)
                
                //TODO should implement a completion handler here!!!!
                sleep(1)
                var content = String()
                do{
                    content = try String.init(contentsOfFile: newfile.path, encoding: .utf8)
                }
                catch {
                    print ("loading image file error")
                }
                let data = cleanRows(file: content)
                var currentData = csv(data: data)
                if (currentData.count > 10 ){
                    addblur(currentFileType: fileIntValue, currentData: currentData)
                }
            }
            
        }
        
    }
    
    
    // TODO put these into a global variable
    //maybe add a switch turning on call here (maybe later with some error checking
    func checkForKindOfFile(name: [String]) -> Int{
        for word in name {
            if (word == "blurPoints")
            {
                return 1
            }
            if (word == "greyPoints"){
                return 2
            }
            if (word == "colorPoints"){
                return 3
            }
            if (word == "hiddenPoints"){
                return 4
            }
        }
        return 0
    }
    
    
    func checkForBackGround(name: [String]) -> String{
        for word in name{
            for back in backGroundImages{
                if word == back
                {
                    return word
                }
            }
        }
        return "MainTes"
    }
    
    
}
extension LoadedImageViewController: ImportDelegate{
    func didReceiveData(boxItems: [BOXItem]) {
        getImportedData(boxitems: boxItems)
    }
    func FileInfoReceived(){
        
    }
}
extension LoadedImageViewController: PickerViewdelegate{
    func getFilestoDownload(files: [FilesToDownload]) {
        checkFilesToDownLoad(Files: files)
    }
}
enum fileTypes{
    case blur, grey, color, isHidden
}
