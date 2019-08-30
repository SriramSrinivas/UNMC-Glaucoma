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
 * Code written by Lyle Reinholz and Abdullahi Mahamed.
 */

import UIKit
import RealmSwift
import VisualEffectView
import BoxContentSDK
import SwiftMessages
import Reachability
import CoreImage
import CoreGraphics


// YO grid is appearing in the images, when grid gets turn on and off we might need to update somehow,



class ViewController: UIViewController, UITextFieldDelegate {
   
    //image heght 1024.0
    //image width 1366.0
    var backImageName = Globals.shared.currentBackGround
    var constimage = UIImage()
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    let screenSize: CGRect = UIScreen.main.bounds
    var bckImage = UIImage()
    var mainImgView = UIView()
    var nameView = UIView()

    var isGridHidden = false
    
    var blurOnIcon = UIImageView()
    var blurOffIcon = UIImageView()
    var colorOnIcon = UIImageView()
    var colorOffIcon = UIImageView()
    var sightOnIcon = UIImageView()
    var sightOffIcon = UIImageView()
    var sunIcon = UIImageView()
    var sunOffIcon = UIImageView()
    
    let export = UIButton()

    let toggleStack = UIStackView()
    let sliderStack = UIStackView()

    var gridViews = [UIView]()

    var distances = [CGFloat]()
    
    
    let intSlider = UISlider()
    let intText = UILabel()
    let alphSlider = UISlider()
    let greySlider = UISlider()
    let blackSlider = UISlider()
    let alphaToggle = UISwitch()
    let luminText = UILabel()
    lazy var customObjectList = [CustomObject]()
    var tempImageView = UIView()
    var iterVal = 0
    
    var customViewUpdateList = [CustomViewUpdate]()
    
    let delete = UIButton()
    var subjectID = ""
    let tempBlur = VisualEffectView()
    lazy var realm = try! Realm()
    var exportCount = 0
    var testPoint: CustomPoint!
    var reach: Reachability!
    lazy var  file = importFile.init()
    lazy var pickerView = PickerView()
    
    //amount of csv and png files uploaded
    
    var csvFilesUploadedCount = 0
    var pngFilesUploadedCount = 0
    //amount of times box tried to upload a file
    var uploadAttempt = 0
    var currentSession: Session!
    
    lazy var bottomMessageView = SwiftMessages()
    var nameLabel = UILabel()
    var timer : Timer?
    var buttonHasBeenPressed = false

    
    override func viewDidLoad() {

        super.viewDidLoad()
        pickerView.delegate = self
        file.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        height = view.frame.height
        width = view.frame.width
        print(view.bounds.size.width)
        print(view.bounds.size.height)
        distances = Globals.shared.getdistancesINCGFloat()

        mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
        mainImgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        mainImgView.addGestureRecognizer(tap)
        
        let sideView = UIView(frame:  CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))
        sideView.layer.zPosition = 2
        sideView.backgroundColor = UIColor(hexString: "#424242")

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)

        SwiftMessages.pauseBetweenMessages = 0
        
        initToggle(sideView: sideView)
        addExportButton(view: sideView)
        addControlIcons()
        addSlider(view: sideView)
        if (backImageName == Globals.shared.backGrounds.first){
            initCustomObjects()
        }
        addGridLineUpdate(mainView: mainImgView)
        if (Globals.shared.importAndExportLoaction == .box) {
            reach = Reachability.forInternetConnection()
            
            reach.reachableBlock = {
                ( reach: Reachability!) -> Void in
                self.reachibiltyChanged(online:true)
            }
            
            reach.unreachableBlock = {
                ( reach: Reachability!) -> Void in
                self.reachibiltyChanged(online:false)
            }
            do {
                try self.reach.startNotifier()
            } catch {
                self.showToast(message: "\(error)", theme: .error)
            }
        }
        
    }
    @objc func reset(){
        buttonHasBeenPressed = false
    }
    override func viewDidAppear(_ animated: Bool) {
        if subjectID == "" {
            enterNameDialog()
        }
    }
   
    func initToggle(sideView: UIView){
        let OH: CGFloat = 768.0
        let OW: CGFloat = 204.8
        let width = sideView.frame.width
        let height = view.frame.height
        
        let gridHeight = sideView.frame.size.height*0.63
        let origHeight = sideView.frame.size.height*0.70
    
        let gridSwitch = UISwitch()
        gridSwitch.frame = CGRect(x: ((40 / OW) * width), y: gridHeight, width: ((50 / OW) * width), height: ((100 / OH) * height))
        gridSwitch.isOn = true 
        gridSwitch.addTarget(self, action: #selector(toggleGrid), for: UIControl.Event.valueChanged)
        
        let origSwitch = UISwitch()
        origSwitch.frame = CGRect(x: ((40 / OW) * width), y: origHeight, width: ((50 / OW) * width), height: ((100 / OH) * height))
        origSwitch.addTarget(self, action: #selector(toggleOriginal), for: UIControl.Event.valueChanged)
        
        let gridText = UILabel()
        gridText.frame = CGRect(x: ((100 / OW) * width), y: gridHeight - ((8 / OH) * height), width: ((150 / OW) * width), height: ((50 / OH) * height))
        gridText.text = "Grid"
        gridText.font = UIFont.systemFont(ofSize: ((20 / OH) * height))
        gridText.textColor = UIColor.white
        
        let origText = UILabel()
        origText.frame = CGRect(x: ((100 / OW) * width), y: origHeight - ((8 / OH) * height), width: ((150 / OW) * width), height: ((50 / OH) * height))
        origText.text = "Original"
        origText.font = UIFont.systemFont(ofSize: ((20 / OH) * height))
        origText.textColor = UIColor.white
        
        
        sideView.addSubview(gridSwitch)
        sideView.addSubview(origSwitch)
        sideView.addSubview(gridText)
        sideView.addSubview(origText)
    }
    //MARK: load background picture
    //idea - present defualt picture but allow for change. grays out picrure and presents available picture on top of view
    func loadImage(mainImgView: UIView){
        
        var image : UIImage
        if backImageName.title == "camera"
        {
            image = Globals.shared.getCameraImage()
        } else {
            image = Globals.shared.currentBackGround.Backgroundimage!
        }
        bckImage = image
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        imageView.image = image
        constimage = resizeImage(image: image, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height)
        mainImgView.addSubview(imageView)
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = width  / size.width
        let heightRatio = height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize

        newSize = CGSize(width: size.width * widthRatio,  height: size.height * heightRatio)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
         return newImage
        
    }
    
    func addSlider(view: UIView){
        let OH: CGFloat = 768.0
        let OW: CGFloat = 204.8
        let width = view.frame.width
        let height = view.frame.height
        blurOnIcon.heightAnchor.constraint(equalToConstant: ((45 / OH) * height)).isActive = true
        blurOnIcon.widthAnchor.constraint(equalToConstant: ((45 / OW) * width)).isActive = true
        
        blurOffIcon.heightAnchor.constraint(equalToConstant: ((45 / OH) * height)).isActive = true
        blurOffIcon.widthAnchor.constraint(equalToConstant: ((45 / OW) * width)).isActive = true
        
        colorOnIcon.heightAnchor.constraint(equalToConstant: ((45 / OH) * height)).isActive = true
        colorOnIcon.widthAnchor.constraint(equalToConstant: ((45 / OW) * width)).isActive = true
        colorOnIcon.transform = colorOnIcon.transform.rotated(by: .pi / 2)
        
        colorOffIcon.heightAnchor.constraint(equalToConstant: ((45 / OH) * height)).isActive = true
        colorOffIcon.widthAnchor.constraint(equalToConstant: ((45 / OW) * width)).isActive = true
        colorOffIcon.transform = colorOffIcon.transform.rotated(by:.pi / 2)
        
        sightOnIcon.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        sightOnIcon.widthAnchor.constraint(equalToConstant: ((50 / OW) * width)).isActive = true
        
        sightOffIcon.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        sightOffIcon.widthAnchor.constraint(equalToConstant: ((50 / OW) * width)).isActive = true
        
        sunIcon.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        sunIcon.widthAnchor.constraint(equalToConstant: ((45 / OW) * width)).isActive = true

        sunOffIcon.heightAnchor.constraint(equalToConstant: ((45 / OH) * height)).isActive = true
        sunOffIcon.widthAnchor.constraint(equalToConstant: ((45 / OW) * width)).isActive = true
        
        intText.heightAnchor.constraint(equalToConstant: ((20 / OH) * height)).isActive = true
        intText.widthAnchor.constraint(equalToConstant: ((20 / OW) * width)).isActive = true
        intText.text = "Blur"
        intText.textColor = UIColor.white
        
        luminText.heightAnchor.constraint(equalToConstant: ((40 / OH) * height)).isActive = true
        luminText.widthAnchor.constraint(equalToConstant: ((50 / OW) * width)).isActive = true
        luminText.text = "Luminosity"
        
        delete.setTitle("Reset", for: UIControl.State.normal)
        delete.heightAnchor.constraint(equalToConstant: ((40 / OH) * height)).isActive = true
        delete.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        delete.backgroundColor = UIColor(hexString: "#f44336")
        delete.addTarget(self, action: #selector(resetTap), for: .touchUpInside)
        
        let tempView = UIButton()
        tempView.heightAnchor.constraint(equalToConstant: ((10 / OH) * height)).isActive = true
        tempView.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        tempView.backgroundColor = UIColor(hexString: "#424242")
        
        let tempView1 = UIButton()
        tempView1.heightAnchor.constraint(equalToConstant: ((10 / OH) * height)).isActive = true
        tempView1.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        tempView1.backgroundColor = UIColor(hexString: "#424242")
        
        let tempView2 = UIButton()
        tempView2.heightAnchor.constraint(equalToConstant: ((10 / OH) * height)).isActive = true
        tempView2.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        tempView2.backgroundColor = UIColor(hexString: "#424242")
        
        alphaToggle.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        alphaToggle.widthAnchor.constraint(equalToConstant: ((30 / OH) * height)).isActive = true
        alphaToggle.addTarget(self, action: #selector(switchAlpha), for: .valueChanged)
        alphaToggle.setOn(true, animated: true)

        intSlider.heightAnchor.constraint(equalToConstant: ((30 / OH) * height)).isActive = true
        intSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        intSlider.addTarget(self, action: #selector(sliderIntensity), for: UIControl.Event.valueChanged)
        intSlider.minimumValue = 0
        intSlider.maximumValue = 10
        intSlider.setValue(0, animated: false)
        
        greySlider.heightAnchor.constraint(equalToConstant: ((30 / OH) * height)).isActive = true
        greySlider.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        greySlider.addTarget(self, action: #selector(sliderGrey), for: UIControl.Event.valueChanged)
        greySlider.minimumValue = 0
        greySlider.maximumValue = 10
        greySlider.setValue(0, animated: false)
        
        blackSlider.heightAnchor.constraint(equalToConstant: ((30 / OH) * height)).isActive = true
        blackSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        blackSlider.addTarget(self, action: #selector(sliderBlack), for: UIControl.Event.valueChanged)
        blackSlider.minimumValue = 0
        blackSlider.maximumValue = 10
        blackSlider.setValue(0, animated: false)

        sliderStack.axis = NSLayoutConstraint.Axis.vertical
        sliderStack.distribution = UIStackView.Distribution.equalSpacing
        sliderStack.alignment = UIStackView.Alignment.center
        sliderStack.spacing = 3.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false
        
        sliderStack.addArrangedSubview(colorOnIcon)
        sliderStack.addArrangedSubview(colorOffIcon)
        sliderStack.addArrangedSubview(blackSlider)
        sliderStack.addArrangedSubview(blurOnIcon)
        sliderStack.addArrangedSubview(blurOffIcon)
        sliderStack.addArrangedSubview(intSlider)
        sliderStack.addArrangedSubview(tempView)
        sliderStack.addArrangedSubview(sunIcon)
        sliderStack.addArrangedSubview(sunOffIcon)
        sliderStack.addArrangedSubview(greySlider)
        sliderStack.addArrangedSubview(tempView1)
        sliderStack.addArrangedSubview(sightOnIcon)
        sliderStack.addArrangedSubview(sightOffIcon)
        sliderStack.addArrangedSubview(alphaToggle)
        sliderStack.addArrangedSubview(tempView2)
        sliderStack.addArrangedSubview(delete)
    
        view.addSubview(sliderStack)

        sliderStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderStack.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 70).isActive = true
        
        enableControl(value: .Disable)
    }
    
    func addExportButton(view: UIView){
        let stack = UIStackView()
        
        let clear = UIButton()
        let menuButton = UIButton()
        let OH: CGFloat = 768.0
        let OW: CGFloat = 204.8
        let width = view.frame.width
        let height = view.frame.height

        export.setTitle("Export", for: UIControl.State.normal)
        export.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        export.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        export.backgroundColor = UIColor(hexString: "#0D47A1")
        export.addTarget(self, action: #selector(getReadyForPickerView), for: .touchUpInside)
        
        clear.setTitle("Start Over", for: UIControl.State.normal)
        clear.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        clear.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        clear.backgroundColor = UIColor(hexString: "#1B5E20")
        clear.addTarget(self, action: #selector(clearTap), for: .touchUpInside)
        
        menuButton.setTitle("Menu", for: UIControl.State.normal)
        menuButton.heightAnchor.constraint(equalToConstant: ((50 / OH) * height)).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: (view.frame.width - ((50 / OW) * width))).isActive = true
        menuButton.backgroundColor = UIColor(hexString: "#1B5E20")
        menuButton.addTarget(self, action: #selector(MenuTapped), for: .touchUpInside)
        
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top:0,left:0,bottom:20,right:0)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.addArrangedSubview(export)
        stack.addArrangedSubview(clear)
        stack.addArrangedSubview(menuButton)
        view.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

    func addGridLineUpdate(mainView: UIView){
        let line1 = UIButton()
        line1.frame = CGRect(x: mainImgView.frame.width*0.3, y: 0, width: 5, height: mainImgView.frame.height)
        line1.layer.borderWidth = 5
        line1.layer.borderColor = UIColor(hexString: "FF9800").cgColor

        let line2 = UIButton()
        line2.frame = CGRect(x: mainImgView.frame.width*0.66, y: 0, width: 5, height: mainImgView.frame.height)
        line2.layer.borderWidth = 5
        line2.layer.borderColor = UIColor(hexString: "FF9800").cgColor

        let line3 = UIButton()
        line3.frame = CGRect(x: 0, y: mainImgView.frame.height*0.5, width: mainImgView.frame.width, height: 5)
        line3.layer.borderWidth = 5
        line3.layer.borderColor = UIColor(hexString: "FF9800").cgColor

        gridViews.append(line1)
        gridViews.append(line2)
        gridViews.append(line3)

        for i in gridViews {
            
            mainImgView.insertSubview(i, aboveSubview: mainImgView)
            mainImgView.bringSubviewToFront(i)
        }
         deSelectAll()
        let image = mainImgView.asImage()
        constimage = resizeImage(image: image, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height)
    }
    
    func addControlIcons(){
        
        let tempImage = {(fileName: String, icon: UIImageView) -> UIImageView in
            
            let theImage = UIImage(named: fileName)
            
            icon.frame = CGRect(x: 0, y: 0, width: (theImage?.size.width)!, height: (theImage?.size.height)!)
            icon.image = theImage
            return icon
        }
        
        blurOnIcon = tempImage("BlurOn",blurOnIcon)
        blurOffIcon = tempImage("BlurOff", blurOffIcon)
        colorOnIcon = tempImage("lumin", colorOnIcon)
        colorOffIcon = tempImage("luminOff", colorOffIcon)
        sightOnIcon = tempImage("SightOn", sightOnIcon)
        sightOffIcon = tempImage("SightOff", sightOffIcon)
        sunIcon = tempImage("lumin", sunIcon)
        sunOffIcon = tempImage("luminOff",sunOffIcon)
    }
    //MARK: location of items on view
   
    func initCustomObjects(){
        
        let H = view.frame.height
        let W = (view.frame.width/5) * 4
        
        customObjectList = createobjects(pictureID: 1, height: H, width: W)
        
        for i in customObjectList {
            i.isUserInteractionEnabled = true
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleCustomObjectTap))
            i.addGestureRecognizer(gestureTap)

            mainImgView.addSubview(i)
            mainImgView.bringSubviewToFront(i)
        }
         deSelectAll()
        let image = mainImgView.asImage()
        constimage = resizeImage(image: image, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height)
    }
    @objc func MenuTapped(_sender: UIButton){
        let vc = MainMenuViewController()
        vc.imageName = backImageName
        self.present(vc, animated: true, completion: nil)
    }

    @objc func toggleGrid(mySwitch: UISwitch) {
        let value = mySwitch.isOn

        switch (value) {
        case false:
            for i in gridViews {
                i.isHidden = true
                isGridHidden = true
                for i in customViewUpdateList{
                    i.colorValueLabel.alpha = 0
                }
            }
        case true:
            for i in gridViews {
                i.isHidden = false
                isGridHidden = false
                for i in customViewUpdateList{
                    i.colorValueLabel.alpha = 1
                }
            }
        }
    }
    
    @objc func toggleOriginal(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        switch value {
        case true:
            mainImgView.isUserInteractionEnabled = false
            enableControl(value: .Disable)
            for i in customViewUpdateList {
                i.isHidden = true
                if i.isLinkedToImage {
                    i.linkedImage.alpha = 1
                }
            }
        case false:
            mainImgView.isUserInteractionEnabled = true
            enableControl(value: .OnlyBlur)
            for i in customViewUpdateList {
                i.isHidden = false
                if i.isLinkedToImage {
                    i.linkedImage.alpha = i.alphaValue
                    
                    if (i.alphaValue == 0){
                        alphaToggle.setOn(false, animated: false)
                    } else {
                        alphaToggle.setOn(true, animated: false)
                    }
                }
                
            }
        default: break
        }
    }
    
    func hideButtonTap(mySwitch: UISwitch!){
        
        let value = mySwitch.isOn
        switch value {
        case false:
            tempImageView.isHidden = true
        case true:
            tempImageView.isHidden = false
        default: break
        }
    }
    
    @objc func sliderIntensity(slider: UISlider){
        let value = slider.value
        let temp = getCurrentActiveView()
        temp.effect = effectType.blur
        for i in customViewUpdateList {
            if i.isActive {
                var temp = i
                changeCustomViewUpdate(customView: &temp, value: Int(value), effect: effectType.blur, constimage: constimage, mainImgView: mainImgView)
                //greySlider.setValue(0, animated: false)
                //blackSlider.setValue(0, animated: false)
                //temp.resetImage()
            }
        }
    }
    
    
    
    @objc func sliderBlack(slider: UISlider){
        let value = slider.value
        var temp = getCurrentActiveView()
        changeCustomViewUpdate(customView: &temp, value: Int(value), effect: effectType.color, constimage: constimage, mainImgView: mainImgView)
//        intSlider.setValue(0, animated: false)
//        greySlider.setValue(0, animated: false)
      
    }
    @objc func sliderGrey(slider: UISlider){
        let value = slider.value
        var temp = getCurrentActiveView()
        changeCustomViewUpdate(customView: &temp, value: Int(value), effect: effectType.grey, constimage: constimage, mainImgView: mainImgView)
//        intSlider.setValue(0, animated: false)
//        blackSlider.setValue(0, animated: false)
       // temp.resetImage()
    }
    
    
    @objc func switchAlpha(sender: UISwitch!){
        
        let temp = getCurrentActiveView()
        
        switch sender.isOn {
        case true:
                temp.linkedImage.alpha = 1
                temp.alphaValue = 1
        case false:

//            greySlider.setValue(0, animated: false)
//            intSlider.setValue(0, animated: false)
            
                temp.linkedImage.alpha = 0
                temp.alphaValue = 0
                for i in customViewUpdateList {
                    if i.isActive {
                        i.blur.blurRadius = CGFloat(0)
                        i.blur.backgroundColor = UIColor.clear
                        i.blur.alpha = 1
                        i.setBlurValue(value: Int(0))
                        i.effect = effectType.isHidden
                    }
                }
        }
    }

    @objc func handleCustomObjectTap(sender: UITapGestureRecognizer){
        print("Custom Object Tapped")
        alphaToggle.isOn = true

        if !customViewActive() {
            for i in customObjectList {
                if (sender.view == i) {
                    
                    createCustomViewUpdate(frame: CGRect(x: i.frame.origin.x, y: i.frame.origin.y, width: i.frame.width, height: i.frame.height))
                    let temp = customViewUpdateList.last
                    temp?.blur.layer.borderColor = UIColor(hexString: "2196F3").cgColor
                    temp?.isLinkedToImage = true
                    temp?.linkedImage = i
                    enableControl(value: .BlurAndAlpha)
                    
                }
            }    
        }
        
    }
    
    func customViewActive() -> Bool{
        var activatedViews: Bool = false
        
        for i in customViewUpdateList{
            if i.isActive {
                i.isActive(value: false)
                activatedViews = true
            }
        }
        
        if !activatedViews {
            enableControl(value: .BlurAndAlpha)
        } else {
            enableControl(value: .Disable)
        }
        
        return activatedViews
        
    }
    func deSelectAll(){
        for i in customViewUpdateList {
            i.isActive(value: false)
        }
    }
    
    @objc func handleTapUpdate(sender: UITapGestureRecognizer){
        
        deSelectAll()
        let image = mainImgView.asImage()
        constimage = resizeImage(image: image, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height)
        
        let temp = sender.view as! CustomViewUpdate
        
        for i in customViewUpdateList {
            if i != temp {
                i.isActive(value: false)
            }
            else {
                //This handles sliders settings when you click on a custom object on the screen
                i.isActive(value: true)
                if ( i.blur.backgroundColor == UIColor.clear){
                    intSlider.setValue(Float(i.viewValue), animated: false)
                } else{
                    intSlider.setValue(0, animated: false)
                }
                if(i.blur.backgroundColor == UIColor.black){
                    greySlider.setValue(Float(i.viewValue), animated: false)
                } else {
                    greySlider.setValue(0, animated: false)
                }
                if i.image.image != nil {
                    blackSlider.setValue(Float(i.viewValue), animated: false)
                } else {
                    blackSlider.setValue(0, animated: false)
                }
                if i.isLinkedToImage{
                    if (i.alphaValue == 0){
                        alphaToggle.setOn(false, animated: false)
                    } else {
                        alphaToggle.setOn(true, animated: false)
                    }
                    enableControl(value: .BlurAndAlpha)
                    enableControl(value: .Black)
                } else {
                    enableControl(value: .OnlyBlur)
                }
            }
        }
    }
    @objc func resetTap(sender: UIButton!){
        
        let temp = getCurrentActiveView()
        
        if temp.isLinkedToImage {
            temp.linkedImage.alpha = 1
        }
        if temp.isLinkedToImage {
            temp.removeFromSuperview()
        }
        customViewUpdateList = customViewUpdateList.filter() { $0 != temp }
        temp.removeFromSuperview()
        enableControl(value: .Disable)
    }
    
    @objc func clearTap(sender: UIButton!){
        exportCount = 0
        let alert = UIAlertController(title: "Screen will be cleared", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default){ _ in
            self.clearScreen()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default){ _ in
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        
        self.present(alert,animated: true)
    }
    
    func clearScreen(){
        
        for i in customViewUpdateList{
            if i.isLinkedToImage{
                i.linkedImage.alpha = 1
            }
            i.removeFromSuperview()
        }
        customViewUpdateList.removeAll()
            
        nameView.subviews.forEach{ $0.removeFromSuperview() }
        nameView.removeFromSuperview()
        
        enterNameDialog()
        
        let patients = realm.objects(PatientData.self)
       
    }
    
    func bottomMessage(_ message:String){
        let view = MessageView.viewFromNib(layout: .statusLine)
            
        view.configureTheme(.success)
        view.configureDropShadow()
        view.button?.setTitle("OK", for: .normal)
        view.buttonTapHandler = { _ in SwiftMessages.hide() }
        view.tapHandler = { _ in SwiftMessages.hide() }
        view.configureContent(body: message)
        
        var config = SwiftMessages.Config()
            
        config.presentationStyle = .bottom
        config.duration = .forever
            
        bottomMessageView.show(config:config,view:view)
    }

    @objc func getReadyForPickerView(){
        if buttonHasBeenPressed == false {
        if (Globals.shared.importAndExportLoaction == .box){
        let FolderId = Globals.shared.getcurrentFolderExport()
        if !(FolderId == "")
        {
            exportTap(FolderID: FolderId)
        } else {
            reach = Reachability.forInternetConnection()
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            currentSession.boxAuthorize()
            file.getFolderItems(withID: "0", completion: { (uploaded:Bool, error:Error?) in
                if let fileError = error {
                    self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                }
                else {
                    
                }
            })
            pickerView = PickerView()
            pickerView.checkingForFiles = false
            pickerView.delegate = self
        }
        else{
            showToast(message: "No Internet Connection", theme: .error)
        }
        }
        } else {
            exportTap(FolderID: "0")
        }
            buttonHasBeenPressed = true
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reset), userInfo: nil, repeats: true)
        }
        
    }
    
    func exportTap(FolderID: String){
    
        currentSession.saveGridData(mainView: mainImgView, customViewList: customViewUpdateList, hasBox: false)
        if (Globals.shared.importAndExportLoaction == dataSource.local) {
            showToast(message: "Files saved to local was a success", theme: .success)
        }
        if (Globals.shared.importAndExportLoaction == dataSource.box) {
            bottomMessage("Uploading Files")
        _ = currentSession.savedFiles.map { (savedFile:FileObject) in
            currentSession.uploadFile(file: savedFile, FolderID: FolderID, completion: { (uploaded:Bool, error:Error?) in
                self.uploadAttempt = self.uploadAttempt + 1
                if let fileError = error {
                    //self.currentSession = Session(currentSubjectId: self.subjectID)
                    self.currentSession.boxAuthorize()
                    //self.currentSession.boxAuthorize()
                    self.showToast(message: "\(fileError.localizedDescription)", theme: .error)

                } else if savedFile.type == FileType.CSV {
                    self.csvFilesUploadedCount = self.csvFilesUploadedCount + 1
                } else {
                    self.pngFilesUploadedCount = self.pngFilesUploadedCount + 1
                }

                if self.uploadAttempt == self.currentSession.savedFiles.count {
                    self.showUploadedMessage()
                }
            })
        }
        
        export.loadingIndicator(true)
        }
        //addWaterMark(name: subjectID)
    }
    
   
   
// Limits the user input to normal characters and limits length, prevents crashing 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        let newString = ((textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString) as String
        return (string == filtered) && (newString.count <= 10)
        //(string == filtered)
    }
    func enterNameDialog(){
        let alert = UIAlertController(title: "Enter Subject Identifier", message: "", preferredStyle: .alert)
        var inputTextField: UITextField?
        //inputTextField?.delegate = self
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Subject ID"
            inputTextField = textField
             inputTextField?.delegate = self
            textField.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
       
        let action = UIAlertAction(title: "Ok", style: .default){ _ in
            self.addWaterMark(name: (inputTextField?.text)!)
            self.nameLabel.textAlignment = .center
            self.nameLabel.center.x = self.nameLabel.frame.maxX
            self.subjectID = (inputTextField?.text)!
            self.currentSession = Session(currentSubjectId: (self.subjectID))
            if (Globals.shared.importAndExportLoaction == .box){
                self.currentSession.boxAuthorize()
            }
        }
        
        action.isEnabled = false
        alert.addAction(action)
        self.present(alert,animated: true)
    }
    
    func showUploadedMessage(){
        bottomMessageView.hideAll()
        SwiftMessages.hide()
        uploadAttempt = 0
        
        if csvFilesUploadedCount > 0 && pngFilesUploadedCount > 0{
            showToast(message: "\(csvFilesUploadedCount) csv and \(pngFilesUploadedCount) png (screenshot) files successfully uploaded", theme: .success)
        } else if csvFilesUploadedCount > 0 {
            showToast(message: "\(csvFilesUploadedCount) csv files successfully uploaded", theme: .success)
        }
        
        export.loadingIndicator(false)
        csvFilesUploadedCount = 0
        pngFilesUploadedCount = 0
    }
    
    func addWaterMark(name: String){
        nameView.frame = CGRect(x: 0, y: mainImgView.frame.height - 15, width: mainImgView.frame.width, height: 15)
        nameView.backgroundColor = UIColor(hexString: "000000")
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 15))
        nameLabel.text = name + " || " + getTodayString()
        nameLabel.textColor = UIColor.white

        nameView.addSubview(nameLabel)
        mainImgView.addSubview(nameView)
        
        let patient = PatientData()
        patient.age = 10
        patient.name = name
        
        try! realm.write {
            realm.add(patient)
        }
    }
    
    

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Image Tapped")
         //deSelectAll()
        let image = mainImgView.asImage()
        constimage = resizeImage(image: image, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height)
        
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
        
        
        tempImageView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //TODO not allo creating off sreen would be nice
        if !customViewActive() {
            createCustomViewUpdate(frame: CGRect(x: touchPoint.x - 100, y: touchPoint.y - 100, width: 200, height: 200))
        }
    }
    func createCustomViewUpdate(frame: CGRect){

        intSlider.setValue(0, animated: false)
        greySlider.setValue(0, animated: false)
        blackSlider.setValue(0, animated: false)
        let c = CustomViewUpdate(frame: frame)
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTapUpdate))
        c.addGestureRecognizer(gestureTap)
        c.layer.zPosition = 2
        //c.blur.blurRadius = 5
        //mainImgView.addSubview(c)
        mainImgView.insertSubview(c, aboveSubview: mainImgView)
        customViewUpdateList.append(c)

        if isGridHidden {
            c.colorValueLabel.alpha = 0
        }
        c.includesEffect()
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        print("Resizing Image")
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getCurrentActiveView() -> CustomViewUpdate{
        
        var temp = CustomViewUpdate()
        for i in customViewUpdateList{
            if i.isActive {
                temp = i
            }
        }
        return temp
    }
    
    func addGridPoints(view: UIView){

        let width = mainImgView.frame.width
        let height = mainImgView.frame.height
        let halfWidth = width/2
        let halfHeight = height/2
        
        for i in distances {
            for j in distances {
                let x = halfWidth + (halfWidth * i)
                let y = halfHeight + (halfHeight * j)

                let c = CustomPoint(point: CGPoint(x: x, y: y))
                if( i == -1){
                    c.backgroundColor = .green
                } else {
                    c.backgroundColor = .red
                }
            
                view.addSubview(c)
            }
        }

    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(format: "%02d",month!) + "-" + String(format: "%02d",day!) + " " + String(format: "%02d",hour!)  + "-" + String(format: "%02d",minute!) + "-" +  String(format: "%02d",second!)
        
        return today_string
        
    }

    func loadDatafromFile(linesOfData: [String]){
        let width = Double((view.frame.size.width/5) * 4)
        var models : [SaveModel]? = []
        for line in linesOfData {
            let model = SaveModel(line: line)
            models?.append(model)
        }
        for model in models! {
            if !(model.effect == .isHidden) {
                let frame = CGRect(x: (model.midx * width) - ((model.width * width)/2), y: model.midy * Double(view.frame.size.height), width: (model.width * Double(mainImgView.frame.size.width)), height: model.height * Double(view.frame.size.height))
                var c = CustomViewUpdate(frame: frame)
                if (model.anchored == effectAnchored.isAnchored) {
                    for i in self.customObjectList{
                        if i.frame.contains(CGPoint(x: model.midx * Double(mainImgView.frame.width), y: model.midy * Double(mainImgView.frame.height))){
                            c.isLinkedToImage = true
                            c.linkedImage = i
                            c.blur.layer.borderColor = UIColor(hexString: "2196F3").cgColor
                        }
                    }
                }
                let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTapUpdate))
                c.addGestureRecognizer(gestureTap)
                changeCustomViewUpdate(customView: &c, value: model.viewValue, effect: model.effect, constimage: constimage, mainImgView: mainImgView)
                mainImgView.insertSubview(c, aboveSubview: mainImgView)
                customViewUpdateList.append(c)
                
                if isGridHidden {
                    c.colorValueLabel.alpha = 0
                }
                
                c.includesEffect()
            } else {
                for i in self.customObjectList{
                    if i.frame.contains(CGPoint(x: model.midx * Double(mainImgView.frame.width), y: model.midy * Double(mainImgView.frame.height))){
                        
                        createCustomViewUpdate(frame: CGRect(x: (model.midx * width) - ((model.width * width)/2), y: model.midy * Double(view.frame.size.height), width: (model.width * Double(mainImgView.frame.size.width)), height: model.height * Double(view.frame.size.height)))
                        let temp = customViewUpdateList.last
                        temp?.blur.layer.borderColor = UIColor(hexString: "2196F3").cgColor
                        
                        temp?.isLinkedToImage = true
                        temp?.linkedImage = i
                        temp?.setColorValue(value: 0)
                        temp?.linkedImage.alpha = 0
                        temp?.blur.blurRadius = 0
                        //temp?.blur.alpha =  0
                        temp?.effect = effectType.isHidden
                        //temp?.alpha = 0
                        enableControl(value: .BlurAndAlpha)
                    }
                }
            }
        }

    }
    
    func getImportedData(boxitems: [BOXItem]){
      
        pickerView.twodimArray = processData(boxitems: boxitems)
        let nav = UINavigationController(rootViewController: pickerView)
        nav.modalPresentationStyle = .overCurrentContext
        
        //vc.twodimArray = twoDArray
        self.present(nav,animated: true, completion: nil)
    }
    
    func checkFilesToDownLoad(Files: [FilesToDownload]){
        if !Files.isEmpty{
            let id = Files.first?.id
            Globals.shared.setcurrentFolderExport(newFolder: id ?? "0")
            exportTap(FolderID: id ?? "0")
        }
        
    }
    
    func enableControl(value: ControlState){
        switch value {
        case .BlurAndAlpha:
            
            intText.textColor = UIColor(hexString: "EEEEEE")
            intText.alpha = 1
            //intSlider.tintColor = UIColor(hexString: "EEEEEE")
            //intSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            alphSlider.tintColor = UIColor(hexString: "EEEEEE")
            alphSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            delete.alpha = 1
            delete.isEnabled =  true
            
            blackSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            blackSlider.tintColor = UIColor(hexString: "EEEEEE")
            
            
            blackSlider.alpha = 1
            blackSlider.isEnabled = true
            
            intSlider.alpha = 1
            intSlider.isEnabled = true
            alphSlider.alpha = 1
            alphSlider.isEnabled = true
            
            blurOnIcon.isHidden = false
            
            colorOffIcon.isHidden = true
            colorOnIcon.isHidden = false
            
            blurOffIcon.isHidden = true
            
            sightOnIcon.isHidden = false
            sightOffIcon.isHidden = true
            
            alphaToggle.isEnabled = true
            alphaToggle.alpha = 1
            
            greySlider.alpha = 1
            greySlider.isEnabled = true
            
            sunIcon.isHidden = false
            sunOffIcon.isHidden = true
            sunIcon.alpha = 1
        case .Disable:
            
            intText.textColor = UIColor(hexString: "9E9E9E")
            intText.alpha = 0.4
            //intSlider.tintColor = UIColor(hexString: "9E9E9E")
            //intSlider.thumbTintColor = UIColor(hexString: "9E9E9E")
            //intSlider.alpha = 0.4
            
            alphSlider.tintColor = UIColor(hexString: "9E9E9E")
            alphSlider.thumbTintColor = UIColor(hexString: "9E9E9E")
            alphSlider.alpha = 0.4
            
            blackSlider.isEnabled = false                                                                                                                                      
            blackSlider.alpha = 0.4
            
            delete.alpha = 0.4
            delete.isEnabled = false
            intSlider.isEnabled = false
            alphSlider.isEnabled = false
            
            blurOnIcon.isHidden = true
            blurOffIcon.isHidden = false
            blurOffIcon.alpha = 0.4
            
            colorOnIcon.isHidden = true
            colorOffIcon.isHidden = false
            colorOffIcon.alpha = 0.4
            
            sightOnIcon.isHidden = true
            sightOffIcon.isHidden = false
            sightOffIcon.alpha = 0.4
            
            alphaToggle.isEnabled = false
            alphaToggle.alpha = 0.4
            
            greySlider.alpha = 0.4
            greySlider.isEnabled = false
            
            sunIcon.isHidden = true
            sunOffIcon.isHidden = false
            sunOffIcon.alpha = 0.4
            
        case .OnlyBlur:
            
            intText.textColor = UIColor(hexString: "EEEEEE")
            intText.alpha = 1
            //intSlider.tintColor = UIColor(hexString: "EEEEEE")
            //intSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
        
            delete.alpha = 1
            delete.isEnabled =  true
            
            blackSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            blackSlider.tintColor = UIColor(hexString: "EEEEEE")
            blackSlider.alpha = 1
            blackSlider.isEnabled = true
            
            alphSlider.tintColor = UIColor(hexString: "9E9E9E")
            alphSlider.thumbTintColor = UIColor(hexString: "9E9E9E")
            alphSlider.isEnabled = false
            alphSlider.alpha = 0.4
            
            intSlider.alpha = 1
            intSlider.isEnabled = true
            
            blurOnIcon.isHidden = false
            blurOffIcon.isHidden = true
            
            colorOnIcon.isHidden = false
            colorOffIcon.isHidden = true
            
            sightOnIcon.isHidden = true
            sightOffIcon.isHidden = false
            
            alphaToggle.isEnabled = false
            alphaToggle.alpha = 0.4
            
            greySlider.alpha = 1
            greySlider.isEnabled = true
            
            sunOffIcon.isHidden = true
            sunIcon.isHidden = false
            sunIcon.alpha = 1
            
        case .Black:
            blackSlider.isEnabled = true
        default:
            break
        }
    }
}

enum ControlState {
    case Disable, OnlyBlur, BlurAndAlpha, Black
}
extension ViewController : PickerViewdelegate{
    func getFilestoDownload(files: [FilesToDownload]) {
        checkFilesToDownLoad(Files: files)
    }
}
extension ViewController : ImportDelegate{
    func didReceiveData(boxItems: [BOXItem]) {
       getImportedData(boxitems: boxItems)
    }
    func FileInfoReceived(){
        
    }
}
