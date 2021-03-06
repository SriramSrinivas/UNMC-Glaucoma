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



//import SwiftUI
import Foundation
import UIKit
import CoreImage
import CoreGraphics
import NotificationCenter
import Reachability

//protocol PickerViewdelegate: class {
//    func getFilestoDownload(files: [FilesToDownload])
//}
//add a way to import and download to Ipad?

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
        origSwitch.isOn = true
        origSwitch.addTarget(self, action: #selector(toggleGrid(mySwitch:)), for: UIControl.Event.valueChanged)
        return origSwitch
    }()
    var importBackgroundSwitch : UISwitch = {
        let origSwitch = UISwitch()
        origSwitch.isOn = false
        origSwitch.addTarget(self, action: #selector(importBackgroundSwitch(_sender:)), for: UIControl.Event.valueChanged)
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
    
    var colorLabel :  UIImageView = {
        let image = UIImage(named: "lumin")
        var temp = UIImageView.init(image: image)
        temp.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
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
    
    var importedImageLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Image", fontSize: 15)
        return temp
    }()
    
    var gridLabel : UITextView = {
        var temp = UITextView()
        nonEditableTextView(&temp, text: "Grid", fontSize: 15)
        return temp
    }()
    
    var backButton : UIButton = {
        var temp = UIButton()
        setUpButton(&temp, title: "Back", cornerRadius: 10, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        return temp
    }()
    var importButton : UIButton = {
        var temp = UIButton()
        setUpButton(&temp, title: "Import", cornerRadius: 10, borderWidth: 0, color: UIColor.gray.cgColor)
        temp.addTarget(self, action: #selector(getNewFile), for: .touchUpInside)
        return temp
    }()
    var blurImageIndicator : UIImageView = {
       let temp = UIImageView()
        
        return temp
    }()
    var textView : UITextView = {
       var temp = UITextView()
        nonEditableTextView(&temp, text: "", fontSize: 12)
        return temp
    }()
    
    var reach: Reachability?
    var backGroundImages = Globals.shared.backGrounds
    var greyCustomViewUpdateList = [CustomViewUpdate]()
    var blurCustomViewUpdateList = [CustomViewUpdate]()
    var colorCustomViewUpdateList = [CustomViewUpdate]()
    var objectCustomViewUpdateList = [CustomViewUpdate]()
    var isHiddenCustomUpdateList = [CustomViewUpdate]()
    //fileTypes blur = 1, grey = 2. color = 3 hidden = 4
    var constImage = UIImage(named: "mainTes")
    //var secondImage : UIImage?
    lazy var file = importFile.init()
    var pickerView = PickerView()
    var LoadedImage : UIImage?
    var loadedIMageBackground = false
    //var constimage = UIImage()
    var currentLocalData : [LocalFileModel]?
    var gridViews = [UIView]()
    let distances = Globals.shared.getdistances()
    var currentSession: Session!
    lazy var localStorage = LoaclStorage.init()
    var timer : Timer?
    var buttonHasBeenPressed = false
    
    func getImportedData(boxitems: [BOXItem]){
        
        pickerView.twodimArray = processData(boxitems: boxitems)
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
        view.backgroundColor = UIColor.darkGray
        constImage = mainImageView.image
        [sideImageView, mainImageView, blurLabel, blurSwitch, illumLabel, blackSwitch, colorLabel, colorSwitch, IsHiddenLabel, allSwitch, allLabel, isHiddenSwitch, gridLabel, gridSwitch, backButton, importButton, importedImageLabel, importBackgroundSwitch, textView].forEach {view.addSubview($0)}
        if (Globals.shared.currentBackGround == Globals.shared.backGrounds.first){
            initCustomObjects(h: 0, w: 0)
        }
        setUpView()
        addGridLineUpdate(mainView: mainImageView)
    }
    @objc func reset(){
        buttonHasBeenPressed = false
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
    func addblur(currentFileType: effectType, currentData: [[String]]){
        let midx = ((view.frame.width/5)*4)/2
        let midy = view.frame.height/2
        let width = (view.frame.width/5)*4
        let height = view.frame.height
        var countx = 1
        var county = 1
       
        constImage = resizeImage(image: constImage!, width: width, height: height)
       
        for number in distances {
            for numb in distances {
                var rectWidth = 15.0
                var rectHeight = 15.0
                if (county != distances.count && county != 1){
                rectWidth = ((distances[county] - distances[county - 1]) * Double(width))/2
                } else if county == 1 {
                   rectWidth = (distances[1] - distances[0]) * Double(width)/2
                }
                if (countx != distances.count && countx != 1){
                rectHeight = ((distances[countx] - distances[countx - 1]) * Double(height))/2
                }else if countx == 1 {
                    rectHeight = (distances[1] - distances[0]) * Double(height)/2
                }
                
                let x = ((numb/2) * Double(height) + Double(midy))
                let y = ((number/2) * Double(width) + Double(midx))
                _ = (numb.nextUp * Double(width) + Double(midx))/2 - x
                let frame = CGRect(x: y, y:x, width: rectWidth, height: rectHeight)

                let value = currentData[countx][county]
                
               
                let a:Int? = Int(value)
               
                if (currentFileType == .blur && value != "0"){
                    var c = CustomViewUpdate(frame: frame)
                    changeCustomViewUpdate(customView: &c, value: a!, effect: .blur, constimage: nil, mainImgView: nil)
                    c.isActive = false
                    c.blurValueLabel.isHidden = true
                    c.colorValueLabel.isHidden = true
                    c.greyValueLabel.isHidden = true
                    c.colorValueLabel.isHidden = false
                    c.colorValueLabel.textColor = .orange
                    c.colorValueLabel.text = value
                    if currentData[countx - 1][county] != value {
                        topBorder(view: c)
//                        if currentData[countx][county - 1] != value  {
////                            c.blurValueLabel.isHidden = false
////                            c.colorValueLabel.isHidden = false
//                            c.greyValueLabel.isHidden = false
//                            c.greyValueLabel.textColor = .yellow
//                        }
                    }
                    if currentData[countx + 1][county] != value  {
                        botBorder(view: c)
                    }
                    if currentData[countx][county - 1] != value {
                        leftBorder(view: c)
                    }
                    if currentData[countx][county + 1] != value {
                        rightBorder(view: c)
                    }
                    c.blur.layer.borderWidth = 0
                    c.layer.borderWidth = 0
                    blurCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                if (currentFileType == .grey && value != "0"){
                    var c = CustomViewUpdate(frame: frame)
                    c.isActive = false
                    changeCustomViewUpdate(customView: &c, value: a!, effect: .grey, constimage: nil, mainImgView: nil)
                    c.blurValueLabel.isHidden = true
                    c.colorValueLabel.isHidden = true
                    c.greyValueLabel.isHidden = true
                    c.colorValueLabel.isHidden = false
                    c.colorValueLabel.textColor = .yellow
                    c.colorValueLabel.text = value
                    if currentData[countx - 1][county] != value {
                        topBorder(view: c)
//                        if currentData[countx][county - 1] != value  {
////                            c.blurValueLabel.isHidden = false
////                            c.colorValueLabel.isHidden = false
//                            c.greyValueLabel.isHidden = false
//                            c.greyValueLabel.textColor = .orange
//                        }
                    }
                    if currentData[countx + 1][county] != value  {
                        botBorder(view: c)
                    }
                    if currentData[countx][county - 1] != value {
                     leftBorder(view: c)
                    }
                    if currentData[countx][county + 1] != value {
                    rightBorder(view: c)
                    }
                    c.blur.layer.borderWidth = 0
                    c.layer.borderWidth = 0
                    //c.layer.borderWidth = 2
                    //c.contentMode = .scaleAs
                    greyCustomViewUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
               if (currentFileType == .color && value != "0"){
                var c = CustomViewUpdate(frame: frame)
                c.isActive = false
                //c.layer.borderColor = UIColor.red.cgColor
                changeCustomViewUpdate(customView: &c, value: a!, effect: .color, constimage: LoadedImage ?? constImage, mainImgView: mainImageView)
                c.blurValueLabel.isHidden = true
                c.colorValueLabel.isHidden = true
                c.greyValueLabel.isHidden = true
                c.colorValueLabel.isHidden = false
                c.colorValueLabel.textColor = .green
                c.colorValueLabel.text = value
                if currentData[countx - 1][county] != value {
                    topBorder(view: c)
//                    if currentData[countx][county - 1] != value  {
//                        //c.blurValueLabel.isHidden = false
//                        c.colorValueLabel.isHidden = false
//                        c.colorValueLabel.textColor = .yellow
//                        //c.greyValueLabel.isHidden = false
//                    }
                }
                if currentData[countx + 1][county] != value  {
                    botBorder(view: c)
                }
                if currentData[countx][county - 1] != value {
                    leftBorder(view: c)
                }
                if currentData[countx][county + 1] != value {
                    rightBorder(view: c)
                }
                //sadfdsaf
                c.clipsToBounds = true
                c.blur.layer.borderWidth = 0
                c.layer.borderWidth = 0
                //c.contentMode = .scaleAspectFit
                colorCustomViewUpdateList.append(c)
                mainImageView.addSubview(c)
                }
                if (currentFileType == .isHidden && value != "0"){
                    let c = CustomViewUpdate(frame: frame)
                    c.layer.zPosition = 2
                    c.isActive = false
                    c.blur.layer.borderWidth = 2
                    c.blur.layer.borderWidth = 0
                    c.blurValueLabel.isHidden = true
                    c.colorValueLabel.isHidden = true
                    c.greyValueLabel.isHidden = true
                    c.colorValueLabel.isHidden = false
                    c.colorValueLabel.textColor = .green
                    c.colorValueLabel.text = value
                    if currentData[countx - 1][county] != value {
                        topBorder(view: c)
//                        if currentData[countx][county - 1] != value  {
//                            c.blurValueLabel.isHidden = false
//                            c.blurValueLabel.textColor = .green
//                        }
                    }
                    if currentData[countx + 1][county] != value  {
                        botBorder(view: c)
                    }
                    if currentData[countx][county - 1] != value {
                        leftBorder(view: c)
                    }
                    if currentData[countx][county + 1] != value {
                        rightBorder(view: c)
                    }
                    c.layer.borderWidth = 0
                    c.layer.borderColor = UIColor.red.cgColor
                    c.blur.backgroundColor = UIColor.black
                    c.blur.alpha = CGFloat(a!/10)
                    c.blur.blurRadius = 0
                    c.setColorValue(value: a!)
                    c.blur.layer.borderWidth = 0
                    //c.layer.borderWidth = 2
                    //c.contentMode = .scaleAs
                    isHiddenCustomUpdateList.append(c)
                    mainImageView.addSubview(c)
                }
                countx = countx + 1
            }
            county = county + 1
            countx = 1
        }
    }
    
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
        
        let OH: CGFloat = 768.0
        let OW: CGFloat = 204.8
        //let newwidth = sideView.frame.width
        let height = view.frame.height
        
        let width = view.bounds.width
        let sideWidth = view.bounds.width/5
        
        mainImageView.anchor(top: view.topAnchor, leading: view.leftAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .zero, size: .init(width: view.frame.width - view.frame.width/5, height: view.frame.height))
        sideImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.rightAnchor, padding: .zero, size: .init(width: view.frame.width/5, height: view.frame.height))
      
        blurLabel.frame = CGRect(x: width - (sideWidth * 0.8), y: ((30 / OH) * height), width: ((50 / OW) * sideWidth), height: ((50 / OH) * height))
        blurSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((40 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
      
        illumLabel.frame = CGRect(x: width - (sideWidth * 0.8), y: ((90 / OH) * height), width: ((50 / OW) * sideWidth), height: ((50 / OH) * height))
        blackSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((100 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
        colorLabel.frame = CGRect(x: width - (sideWidth * 0.8), y: ((150 / OH) * height), width: ((50 / OW) * sideWidth), height: ((50 / OH) * height))
        colorSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((160 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
        IsHiddenLabel.frame = CGRect(x: width - (sideWidth * 0.8), y: ((210 / OH) * height), width: ((50 / OW) * sideWidth), height: ((50 / OH) * height))
        isHiddenSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((220 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
         allLabel.anchor(top: IsHiddenLabel.bottomAnchor, leading: mainImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: ((25 / OH) * height), left: width - (sideWidth * 0.85), bottom: 0, right: 0), size: .init(width: ((70 / OW) * sideWidth), height: ((25 / OH) * height)))
        allSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((280 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
//        allLabel.anchor(top: IsHiddenLabel.bottomAnchor, leading: mainImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: ((25 / OH) * height), left: width - (sideWidth * 0.85), bottom: 0, right: 0), size: .init(width: ((70 / OW) * sideWidth), height: ((25 / OH) * height)))
//        allSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((280 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
        gridLabel.anchor(top: allLabel.bottomAnchor, leading: mainImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: ((30 / OH) * height), left: width - (sideWidth * 0.85), bottom: 0, right: 0), size: .init(width: ((70 / OW) * sideWidth), height: ((25 / OH) * height)))
        gridSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((340 / OH) * height), width: ((100 / OW) * width), height: ((50 / OH) * height))
        
        importedImageLabel.anchor(top: gridLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init( top: ((35 / OH) * height), left: ((20 / OW) * sideWidth), bottom: 0, right: 0), size: .init(width: ((100 / OW) * sideWidth), height: ((50 / OH) * height)))
        importBackgroundSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((400 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
        backButton.anchor(top: importedImageLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: ((25 / OH) * height), left: ((50 / OW) * sideWidth), bottom: 0, right: 0), size: .init(width: ((100 / OW) * sideWidth), height: ((50 / OH) * height)))
        importButton.anchor(top: backButton.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init(top: ((25 / OH) * height), left: ((50 / OW) * sideWidth), bottom: 0, right: 0), size: .init(width: ((100 / OW) * sideWidth), height: ((50 / OH) * height)))
        
        textView.anchor(top: importButton.bottomAnchor, leading: sideImageView.leftAnchor, bottom: view.bottomAnchor, trailing: view.rightAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
//        importedImageLabel.anchor(top: gridLabel.bottomAnchor, leading: sideImageView.leftAnchor, bottom: nil, trailing: nil, padding: .init( top: ((35 / OH) * height), left: ((20 / OW) * sideWidth), bottom: 0, right: 0), size: .init(width: ((100 / OW) * sideWidth), height: ((50 / OH) * height)))
//        importBackgroundSwitch.frame = CGRect(x: width - (sideWidth * 0.5), y: ((400 / OH) * height), width: ((100 / OW) * sideWidth), height: ((50 / OH) * height))
        
    }
    
    func initCustomObjects(h:CGFloat, w:CGFloat){
        
        let H = view.frame.height
        let W = (view.frame.width/5) * 4
        
        customObjectList = createobjects(pictureID: 1, height: H, width: W)
        
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
    
    @objc func importBackgroundSwitch(_sender: UISwitch){
        if (importBackgroundSwitch.isOn == false)
        {
            self.mainImageView.image = constImage
            self.mainImageView.reloadInputViews()
        }
        else{
            let image = LoadedImage
            if !loadedIMageBackground {
                importBackgroundSwitch.setOn(false, animated: true)
            } else {
                self.mainImageView.image = image
                self.mainImageView.reloadInputViews()
            }
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
            isHiddenSwitch.setOn(true, animated: true)
            for i in isHiddenCustomUpdateList {
                i.isHidden = false
            }
            for i in greyCustomViewUpdateList{
                i.isHidden = false
            }
            for i in blurCustomViewUpdateList{
                i.isHidden = false
            }
        }
        else{
          HideAllObjects()
        }
    }
    func HideAllObjects(){
        blackSwitch.setOn(false, animated: true)
        blurSwitch.setOn(false, animated: true)
        colorSwitch.setOn(false, animated: true)
        isHiddenSwitch.setOn(false, animated: true)
        for i in colorCustomViewUpdateList{
            i.isHidden = true
        }
        for i in greyCustomViewUpdateList{
            i.isHidden = true
        }
        for i in blurCustomViewUpdateList{
            i.isHidden = true
        }
        for i in blurCustomViewUpdateList{
            i.isHidden = true
        }
    }
        
    
    @objc func isHiddenSwitch(_sender: UISwitch){
        if (_sender.isOn == true){
            for i in isHiddenCustomUpdateList{
                i.isHidden = false
                i.layer.borderWidth = 0
            }
        }
        else{
            for i in isHiddenCustomUpdateList{
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
        let vc = MainMenuViewController()
        self.present(vc,animated: true, completion: nil)
    }
    
    @objc func getNewFile(){
        let count = Globals.shared.importAndExportLoaction
        if (count == .box){
            if buttonHasBeenPressed == false {
        self.reach = Reachability.forInternetConnection()
        //TODO perform internet check 
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            HideAllObjects()
        greyCustomViewUpdateList.removeAll()
        blurCustomViewUpdateList.removeAll()
        colorCustomViewUpdateList.removeAll()
        objectCustomViewUpdateList.removeAll()
        isHiddenCustomUpdateList.removeAll()
        textView.text = ""
            file.getFolderItems(withID: "0", completion: { (uploaded:Bool, error:Error?) in
                if let fileError = error {
                    self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                    //let box = BOXContentClient
                    self.currentSession = Session(currentSubjectId: ("import"))
                    self.currentSession.boxAuthorize()
                }
                else {
        
                }
            })
        pickerView = PickerView()
        pickerView.delegate = self
        }
        else{
           showToast(message: "No Internet Connection", theme: .error)
        }
                buttonHasBeenPressed = true
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reset), userInfo: nil, repeats: true)
            }
        } else {
            HideAllObjects()
            greyCustomViewUpdateList.removeAll()
            blurCustomViewUpdateList.removeAll()
            colorCustomViewUpdateList.removeAll()
            objectCustomViewUpdateList.removeAll()
            isHiddenCustomUpdateList.removeAll()
            textView.text = ""
            pickerView = PickerView()
            pickerView.delegate = self
            currentSession = Session(currentSubjectId: "hello")
            var hello : [LocalFileModel] = []
            do {
                try hello = localStorage.loadData()
            } catch {
                showToast(message: "Error In loading Data", theme: .error)
                hello = localStorage.getDataThatDidLoad()
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
    //name then id
    func checkFilesToDownLoad(Files: [FilesToDownload]){
        //let source = dataSource.local
        if (Globals.shared.importAndExportLoaction == dataSource.box) {
        if Files.isEmpty{
            //do nothing
        }
        else{
            for file in Files {
                let names = file.name.components(separatedBy: "_")
                
                checkNameForBackGrounds(name: names)
                //let back = backgroundChanged()
                let back = Globals.shared.currentBackGround
                Globals.shared.cameraImage = back.Backgroundimage
                mainImageView.image = back.Backgroundimage
                constImage = Globals.shared.currentBackGround.Backgroundimage
                
                mainImageView.reloadInputViews()
                //if returns 0 it failed
                let fileIntValue = checkForKindOfFile(name: names)
                let effect = effectToString(name: fileIntValue)
                textView.text.append(names.first! + "_" + effect + "\n")
                let group = DispatchGroup()
                group.enter()
                
                let newfile = self.file.downLoadFile(withId: file.id, completion: { (uploaded:Bool, error:Error?) in
                    if let fileError = error {
                        self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                    }
                    else {
                        self.showToast(message: "\(file.name) has Successfully been downloaded", theme: .success)
                        group.leave()
                    }
                })
                group.notify(queue: .main) {
                var content = String()
                do{
                    if (fileIntValue == .blur || fileIntValue == .grey || fileIntValue == .color || fileIntValue == .isHidden){
                    content = try String.init(contentsOfFile: newfile.path, encoding: .utf8)
                    let data = self.cleanRows(file: content)
                    let currentData = self.csv(data: data)
                    if (checksDataForErrors(newData: currentData) ){
                        self.addblur(currentFileType: fileIntValue, currentData: currentData)
                        self.turnOnGrid(filetype: fileIntValue)
                    }
                    //self.turnOnGrid(filetype: fileIntValue)
                    }
                    else if fileIntValue == .PNG{
                        if let data = try? Data(contentsOf: newfile) {
                            if let image = UIImage(data: data) {
                                self.LoadedImage = image
                                self.mainImageView.image = image
                                self.mainImageView.reloadInputViews()
                                self.importBackgroundSwitch.setOn(true, animated: true)
                                self.loadedIMageBackground = true
                            }
                        }
                    }
                }
                catch {
                    
                    self.showToast(message: "Did not load Data from \(file.name), Incorrect: FileType/Data", theme: .error)
                    
                }
            }
            }
        }
        } else {
            let id = Int(Files.first!.id)!
            let filesToLoad = currentLocalData![id]
            let names = Files.first!.name.components(separatedBy: "_")
            if let image = UIImage(data: filesToLoad.image! as Data) {
                self.LoadedImage = image
                self.mainImageView.image = image
                self.mainImageView.reloadInputViews()
                self.importBackgroundSwitch.setOn(true, animated: true)
                self.loadedIMageBackground = true
                //}
            }
            //sdafads
            checkNameForBackGrounds(name: names)
            //let back = backgroundChanged()
            //back = "MainTes"
            //mainImageView.image = image
            constImage = Globals.shared.currentBackGround.Backgroundimage
            mainImageView.reloadInputViews()
            do{
                textView.text.append(filesToLoad.name!)
                //filesToLoad.blurdata
                var currentData = self.csv(data: filesToLoad.blurdata!)
                if (checksDataForErrors(newData: currentData) ){
                        self.addblur(currentFileType: .blur, currentData: currentData)
                        self.turnOnGrid(filetype: effectType.blur)
                }
                currentData = self.csv(data: filesToLoad.colordata!)
                if (checksDataForErrors(newData: currentData) ){
                    self.addblur(currentFileType: .color, currentData: currentData)
                    self.turnOnGrid(filetype: effectType.color)
                }
                currentData = self.csv(data: filesToLoad.greydata!)
                if (checksDataForErrors(newData: currentData) ){
                    self.addblur(currentFileType: .grey, currentData: currentData)
                    self.turnOnGrid(filetype: effectType.grey)
                }
                currentData = self.csv(data: filesToLoad.ishiddendata!)
                if (checksDataForErrors(newData: currentData) ){
                    self.addblur(currentFileType: .isHidden, currentData: currentData)
                    self.turnOnGrid(filetype: effectType.isHidden)
                }
            }
        }
    }
    func turnOnGrid(filetype: effectType){
        if filetype == .blur {
            blurSwitch.setOn(true, animated: true)
        }
        else if filetype == .grey {
            blackSwitch.setOn(true, animated: true)
        }
        else if filetype == .color {
            colorSwitch.setOn(true, animated: true)
        }
        else if filetype == .isHidden {
            isHiddenSwitch.setOn(true, animated: true)
        }
    }
    
    // TODO put these into a global variable
    //maybe add a switch turning on call here (maybe later with some error checking
    func checkForKindOfFile(name: [String]) -> effectType{
        for word in name {
            if (word == "blurPoints")
            {
                return .blur
            }
            if (word == "greyPoints"){
                return .grey
            }
            if (word == "colorPoints"){
                return .color
            }
            if (word == "hiddenPoints"){
                return .isHidden
            }
            if (word == "screenshot"){
                return .PNG
            }
        }
        return .incorrectEffectType
    }
    func effectToString(name: effectType) -> String{
        if (name == .blur)
        {
            return "blurPoints"
        }
        if (name == .grey){
            return "greyPoints"
        }
        if (name == .color){
            return "colorPoints"
        }
        if (name == .isHidden){
            return "hiddenPoints"
        }
        if (name == .PNG){
            return "screenshot"
        }
        return "incorrectEffectType"
    }
    
    func checkNameForBackGrounds(name: [String]){
        for word in name {
            for back in Globals.shared.backGrounds {
                if word == back.title {
                    Globals.shared.currentBackGround = back
                }
            }
            if word == "camera" {
                let temp = BackgroundImage()
                temp.Backgroundimage = nil
                temp.ID = 1
                temp.title = "camera"

                Globals.shared.currentBackGround = temp
            }
        }
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
