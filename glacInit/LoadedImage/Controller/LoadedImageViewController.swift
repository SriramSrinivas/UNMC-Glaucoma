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

// maybe have a temp storage on device? so they dont have to keep reloading the data
// create a table view controller to grab the selected file
// prob similiar to the collection view but
// regex file and check the closest 5 in either direction
// if the name and the date and the time match then grab them
// and display them according to the file type they are (eg blur, grey, or colorless)
// the files should be deleted after that

//import SwiftUI
import Foundation
import UIKit
import CoreImage
import CoreGraphics

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
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(grewSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()

    var blackSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(blackSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var colorSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(colorSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var isHiddenSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(isHiddenSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var allSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(allSwitch(_sender:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    var gridSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(toggleGrid(mySwitch:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    
    var greyLabel : UITextView = {
       var temp = UITextView()
        nonEditableTextView(&temp, text: "Grey", fontSize: 15)
        return temp
    }()
    
    var blackLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Black", fontSize: 15)
        return temp
    }()
    
    var colorLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Color", fontSize: 15)
        return temp
    }()
    
    var allLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "isHidden", fontSize: 15)
        return temp
    }()
    
    var isHiddenLabel : UITextView = {
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
        setUpButton(&temp, title: "Back", cornerRadius: 25, borderWidth: 0, color: "red")
        temp.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        return temp
    }()
    
    var greyCustomViewUpdateList = [CustomViewUpdate]()
    var blurCustomViewUpdateList = [CustomViewUpdate]()
    var colorCustomViewUpdateList = [CustomViewUpdate]()
    var objectCustomViewUpdateList = [CustomViewUpdate]()
    //fileTypes blur = 1, grey = 2. color = 3 hidden = 4
    var constImage = UIImage(named: "mainTes")
    
    var gridViews = [UIView]()
    let distances =  [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .red

        [sideImageView, mainImageView, greyLabel, blurSwitch, blackLabel, blackSwitch, colorLabel, colorSwitch, allLabel, allSwitch, isHiddenLabel, isHiddenSwitch, gridLabel, gridSwitch, backButton].forEach {view.addSubview($0)}
        initCustomObjects(h: 0, w: 0)
    
        setUpView()
    
        addGridLineUpdate(mainView: mainImageView)
    }
    
    func importFilesssss(){
        
    }
    //    var data = readDataFromCSV(fileName: kCSVFileName, fileType: kCSVFileExtension)
    //    data = cleanRows(file: data)
    //    let csvRows = csv(data: data)
    //    print(csvRows[1][1]) //UXM n. 166/167.
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
                
                let x = ((numb/2) * Double(width) + Double(midx))
                let y = ((number/2) * Double(height) + Double(midy))
                _ = (numb.nextUp * Double(width) + Double(midx))/2 - x
                let frame = CGRect(x: x, y:y, width: 15, height: 15)

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
                    c.blur.layer.borderWidth = 1
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
        greyLabel.anchor(top: sideImageView.topAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 100, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        blurSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 150, width: 100, height: 50)
        
        blackLabel.anchor(top: greyLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        blackSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 225, width: 100, height: 50)
        colorLabel.anchor(top: blackLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        colorSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 300, width: 100, height: 50)
        
        allLabel.anchor(top: colorLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        isHiddenSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 375, width: 100, height: 50)
         isHiddenLabel.anchor(top: allLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        allSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 450, width: 100, height: 50)
        
        gridLabel.anchor(top: isHiddenLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        gridSwitch.frame = CGRect(x: view.bounds.size.width - 140, y: 525, width: 100, height: 50)
        backButton.anchor(top: gridSwitch.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: .init(width: 100, height: 50))
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
        
    }
    func split(){

        let test = "HELLO_MAN_THIS_IS"
        
        

        //test.sp
        
        //var string
        
        //make a truct for the data or a model i suppose
        // insta the the structs
        //compare them
        // and get the import to import the other needed ones
        //if a png is selected grab the other but dont do anything with the png
        // 
        
    }
    //expects some sort of model
    // comapres model and returns an array of the model
    // expected parameter [SubjectID][date]
    func comparesFolderItemsSelected(listings: [folderListingViewModel]) -> [folderListingViewModel]{
        var retList = [folderListingViewModel]()
        //let listings = [folderListingViewModel]()
        for folder in listings {
//            if (folder.name[0] == FolderItems[0] && folder.name[4] == FolderItems[1]){
//                retList.append(folder)
//            }
        }
        return retList
    }
    
    func callDownloads(specifiedItems: [folderListingViewModel]) -> [Int] {
        var filetypes = [0]
        for items in specifiedItems{
            let file = items.name[5].split(separator: ".")
            if (file.last == "csv"){
                //downloadFile
                if (items.name[3] == "blurPoints")
                {
                    filetypes.append(1)
                }
                if (items.name[3] == "greyPoints"){
                    filetypes.append(2)
                }
                if (items.name[3] == "ColorPoints"){
                    filetypes.append(3)
                }
                if (items.name[3] == "hiddenPoints"){
                    filetypes.append(4)
                }
            }
        }
        return filetypes
    }
    //Mark: TODO
    //only should be 5
    //downloading should be done here then
    func checkAountOfFilesDownlaodinf(){
        
        
        let file = importFile.init(subjectId: "", backGroundId: "", file: FileType.CSV)
        file.downLoadFile()
        let newfile = file.downloadedFile()
        file.getFolderItems()
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
              //  addblur(fileTypes: [1,2])
            }

    }
    
    
}
enum fileTypes{
    case blur, grey, color, isHidden
}
