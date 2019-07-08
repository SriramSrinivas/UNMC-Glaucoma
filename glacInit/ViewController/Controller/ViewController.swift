import UIKit
import RealmSwift
import VisualEffectView
import BoxContentSDK
import SwiftMessages
import Reachability
import CoreImage
import CoreGraphics

// YOOOOOO FIX THE IMAGE BEING TO BIG (will be fixed when constraining the images to the screen)

class ViewController: UIViewController{
    
    //image heght 1024.0
    //image width 1366.0
    var backImageName = "mainTes"
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
    var customObjectList = [CustomObject]()
    //var customBlackObjectList = [CustomObject]()
    var tempImageView = UIView()
    var iterVal = 0
    
    var customViewUpdateList = [CustomViewUpdate]()
    
    let delete = UIButton()
    var subjectID = ""
    let tempBlur = VisualEffectView()
    let realm = try! Realm()
    var exportCount = 0
    var testPoint: CustomPoint!
    var reach: Reachability!
    
    //amount of csv and png files uploaded
    var csvFilesUploadedCount = 0
    var pngFilesUploadedCount = 0
    //amount of times box tried to upload a file
    var uploadAttempt = 0
    var currentSession: Session!
    
    var bottomMessageView = SwiftMessages()
    var nameLabel = UILabel()
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        height = view.frame.height
        width = view.frame.width
        print(view.bounds.size.width)
        print(view.bounds.size.height)
        distances =  [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]

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
        initCustomObjects()
        addGridLineUpdate(mainView: mainImgView)
        
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

        //addGridPoints(view: mainImgView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        enterNameDialog()
    }
    override func viewWillAppear(_ animated: Bool) {
       // enterNameDialog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initToggle(sideView: UIView){
        
        let gridHeight = sideView.frame.size.height*0.60
        let origHeight = sideView.frame.size.height*0.70
    
        let gridSwitch = UISwitch()
        gridSwitch.frame = CGRect(x: 30, y: gridHeight, width: 50, height: 100)
        gridSwitch.isOn = true 
        gridSwitch.addTarget(self, action: #selector(toggleGrid), for: UIControl.Event.valueChanged)
        
        let origSwitch = UISwitch()
        origSwitch.frame = CGRect(x: 30, y: origHeight, width: 50, height: 100)
        origSwitch.addTarget(self, action: #selector(toggleOriginal), for: UIControl.Event.valueChanged)
        
        let gridText = UILabel()
        gridText.frame = CGRect(x: 100, y: gridHeight - 8, width: 150, height: 50)
        gridText.text = "Grid"
        gridText.textColor = UIColor.white
        
        let origText = UILabel()
        origText.frame = CGRect(x: 100, y: origHeight - 8, width: 150, height: 50)
        origText.text = "Original"
        origText.textColor = UIColor.white
        
        
        sideView.addSubview(gridSwitch)
        sideView.addSubview(origSwitch)
        sideView.addSubview(gridText)
        sideView.addSubview(origText)
    }
    //MARK: load background picture
    //idea - present defualt picture but allow for change. grays out picrure and presents available picture on top of view
    func loadImage(mainImgView: UIView){
        
        

        let image = UIImage(named: backImageName)
       
        //epiaFilter(image, intensity: 2)
        //this will change the image color
        //image = image?.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7), blendMode: .luminosity)
        
        bckImage = image!
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        
        imageView.image = image
        //constimage = imageView.image!
        constimage = resizeImage(image: image!, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height)
        print("know these")
//        print(mainImgView.frame.size.height)
//        print(mainImgView.frame.size.width)
        
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
        
        blurOnIcon.heightAnchor.constraint(equalToConstant: 45).isActive = true
        blurOnIcon.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        blurOffIcon.heightAnchor.constraint(equalToConstant: 45).isActive = true
        blurOffIcon.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        sightOnIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sightOnIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        sightOffIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sightOffIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        sunIcon.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sunIcon.widthAnchor.constraint(equalToConstant: 45).isActive = true

        sunOffIcon.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sunOffIcon.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        intText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intText.widthAnchor.constraint(equalToConstant: 20).isActive = true
        intText.text = "Blur"
        intText.textColor = UIColor.white
        
        luminText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        luminText.widthAnchor.constraint(equalToConstant: 50).isActive = true
        luminText.text = "Luminosity"
        
        delete.setTitle("Reset", for: UIControl.State.normal)
        delete.heightAnchor.constraint(equalToConstant: 50).isActive = true
        delete.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        delete.backgroundColor = UIColor(hexString: "#f44336")
        delete.addTarget(self, action: #selector(resetTap), for: .touchUpInside)
        
        let tempView = UIButton()
        tempView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        tempView.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        tempView.backgroundColor = UIColor(hexString: "#424242")
        
        let tempView1 = UIButton()
        tempView1.heightAnchor.constraint(equalToConstant: 10).isActive = true
        tempView1.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        tempView1.backgroundColor = UIColor(hexString: "#424242")
        
        let tempView2 = UIButton()
        tempView2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        tempView2.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        tempView2.backgroundColor = UIColor(hexString: "#424242")
        
        alphaToggle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        alphaToggle.widthAnchor.constraint(equalToConstant: 40).isActive = true
        alphaToggle.addTarget(self, action: #selector(switchAlpha), for: .valueChanged)
        alphaToggle.setOn(true, animated: true)

        intSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        intSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        intSlider.addTarget(self, action: #selector(sliderIntensity), for: UIControl.Event.valueChanged)
        intSlider.minimumValue = 0
        intSlider.maximumValue = 10
        intSlider.setValue(0, animated: false)
        
        greySlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        greySlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        greySlider.addTarget(self, action: #selector(sliderGrey), for: UIControl.Event.valueChanged)
        greySlider.minimumValue = 0
        greySlider.maximumValue = 10
        greySlider.setValue(0, animated: false)
        
        blackSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blackSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        blackSlider.addTarget(self, action: #selector(sliderBlack), for: UIControl.Event.valueChanged)
        blackSlider.minimumValue = 0
        blackSlider.maximumValue = 10
        blackSlider.setValue(0, animated: false)

        sliderStack.axis = NSLayoutConstraint.Axis.vertical
        sliderStack.distribution = UIStackView.Distribution.equalSpacing
        sliderStack.alignment = UIStackView.Alignment.center
        sliderStack.spacing = 4.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

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

        sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        enableControl(value: .Disable)
    }
    
    func addExportButton(view: UIView){
        let stack = UIStackView()
        
        let clear = UIButton()
        let newBackground = UIButton()

        export.setTitle("Export", for: UIControl.State.normal)
        export.heightAnchor.constraint(equalToConstant: 50).isActive = true
        export.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        export.backgroundColor = UIColor(hexString: "#0D47A1")
        export.addTarget(self, action: #selector(exportTap), for: .touchUpInside)
        
        clear.setTitle("Start Over", for: UIControl.State.normal)
        clear.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clear.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        clear.backgroundColor = UIColor(hexString: "#1B5E20")
        clear.addTarget(self, action: #selector(clearTap), for: .touchUpInside)
        
        newBackground.setTitle("Switch", for: UIControl.State.normal)
        newBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newBackground.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        newBackground.backgroundColor = UIColor(hexString: "#1B5E20")
        newBackground.addTarget(self, action: #selector(setNewBackground), for: .touchUpInside)
        
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top:0,left:0,bottom:20,right:0)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.addArrangedSubview(export)
        stack.addArrangedSubview(clear)
        stack.addArrangedSubview(newBackground)
        view.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //addWaterMark(name: "suh dude")
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
        sightOnIcon = tempImage("SightOn", sightOnIcon)
        sightOffIcon = tempImage("SightOff", sightOffIcon)
        sunIcon = tempImage("lumin", sunIcon)
        sunOffIcon = tempImage("luminOff",sunOffIcon)
    }
    //MARK: location of items on view
   
    func initCustomObjects(){
        
        customObjectList = createobjects(pictureID: 1, height: height, width: width)
        
        for i in customObjectList {
            i.isUserInteractionEnabled = true
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleCustomObjectTap))
            i.addGestureRecognizer(gestureTap)

            mainImgView.addSubview(i)
            mainImgView.bringSubviewToFront(i)
        }
    }
    @objc func setNewBackground(_sender: UIButton){
        //warn user that this will delete self
        let layout = UICollectionViewFlowLayout()
        let vc = BackgroundChangeController(collectionViewLayout: layout)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }

    @objc func toggleGrid(mySwitch: UISwitch) {
        let value = mySwitch.isOn

        switch (value) {
        case false:
            for i in gridViews {
                i.isHidden = true
                isGridHidden = true
                for i in customViewUpdateList{
                    i.valueLabel.alpha = 0
                }
            }
        case true:
            for i in gridViews {
                i.isHidden = false
                isGridHidden = false
                for i in customViewUpdateList{
                    i.valueLabel.alpha = 1
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
        
        for i in customViewUpdateList {
            if i.isActive {
                i.blur.blurRadius = CGFloat(value)
                i.blur.backgroundColor = UIColor.clear
                i.blur.alpha = 1
                i.setValue(value: Int(value))

                greySlider.setValue(0, animated: false)
                blackSlider.setValue(0, animated: false)
                temp.resetImage()
            }
        }
    }
    
    
    
    @objc func sliderBlack(slider: UISlider){
        var value = slider.value
        
        value = value/10
        var cropImage = constimage
        let temp = getCurrentActiveView()
        temp.setImageConst(images: constimage)
        cropImage = cropImage.crop(rect: temp.frame)
        cropImage = cropImage.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(value)), blendMode: .luminosity)
        mainImgView.insertSubview(temp, belowSubview: customObjectList.first!)
//        self.view.layer.zPosition = 1;
        //temp.layer.zPosition = 100;
        if (value < 0.1){
            temp.resetImage()
        }
        else{
            temp.addImage(images: cropImage)
        }
        view.layoutIfNeeded()
        temp.setValue(value: Int(value * 10))
        
        temp.blur.backgroundColor = nil
        intSlider.setValue(0, animated: false)
        greySlider.setValue(0, animated: false)
      
    }
    @objc func sliderGrey(slider: UISlider){
        var value = slider.value
        value = value/10
        let temp = getCurrentActiveView()
        temp.blur.backgroundColor = UIColor.black
        temp.blur.alpha = CGFloat(value)
        temp.blur.blurRadius = 0
        temp.setValue(value: Int(value * 10))
        
        

        intSlider.setValue(0, animated: false)
        blackSlider.setValue(0, animated: false)
        temp.resetImage()
    }
    
    @objc func switchAlpha(sender: UISwitch!){
        
        let temp = getCurrentActiveView()
        
        switch sender.isOn {
        case true:
                temp.linkedImage.alpha = 1
                temp.alphaValue = 1
        case false:

            greySlider.setValue(0, animated: false)
            intSlider.setValue(0, animated: false)
            
                temp.linkedImage.alpha = 0
                temp.alphaValue = 0
                for i in customViewUpdateList {
                    if i.isActive {
                        i.blur.blurRadius = CGFloat(0)
                        i.blur.backgroundColor = UIColor.clear
                        i.blur.alpha = 1
                        i.setValue(value: Int(0))
                    }
                }
        }
    }

    @objc func handleCustomObjectTap(sender: UITapGestureRecognizer){
        print("Custom Object Tapped")
        //alphSlider.setValue(10, animated: false)

        alphaToggle.isOn = true

        if !customViewActive() {
            for i in customObjectList {
                if (sender.view == i) {
                    
                    createCustomViewUpdate(frame: CGRect(x: i.frame.origin.x, y: i.frame.origin.y, width: i.frame.width, height: i.frame.height))
                    let temp = customViewUpdateList.last
                    temp?.blur.layer.borderColor = UIColor(hexString: "2196F3").cgColor
                    
//                        var cropImage = constimage
//                        cropImage = cropImage.crop(rect: temp!.frame)
//                        cropImage = cropImage.tint(color: UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(i.alpha)), blendMode: .luminosity)
                    
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
    
    @objc func handleTapUpdate(sender: UITapGestureRecognizer){
        
        let temp = sender.view as! CustomViewUpdate
        
        for i in customViewUpdateList {
            if i != temp {
                i.isActive(value: false)
            }
            else {
                i.isActive(value: true)
                if ( i.blur.backgroundColor == UIColor.clear){
                    blackSlider.setValue(Float(i.viewValue), animated: false)
                }
                else{
                    blackSlider.setValue(0, animated: false)
                }
                if(i.blur.backgroundColor == UIColor.black){
                    greySlider.setValue(Float(i.viewValue), animated: false)
                } else {
                    greySlider.setValue(0, animated: false)
                }
                
                intSlider.setValue(Float(i.blur.blurRadius), animated: false)
                

                if i.isLinkedToImage{
                    //alphSlider.setValue(Float(i.alphaValue), animated: false)
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
                //enableControl(value: .Black)
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
        //for i in patients {
            //print("Stored Patient: \(i.name)")
        //}
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

    
    @objc func exportTap(sender: UIButton!){
        bottomMessage("Uploading Files")
        exportCount = exportCount + 1

        
        currentSession.saveGridData(mainView: mainImgView, customViewList: customViewUpdateList)
    
        _ = currentSession.savedFiles.map { (savedFile:FileObject) in
            currentSession.uploadFile(file: savedFile, completion: { (uploaded:Bool, error:Error?) in
                self.uploadAttempt = self.uploadAttempt + 1
                if let fileError = error {
                    //self.currentSession = Session(currentSubjectId: self.subjectID)
                    //self.currentSession.boxAuthorize() 
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
    
    //MARK: box autho
    func enterNameDialog(){
        let alert = UIAlertController(title: "Enter Subject Identifier", message: "", preferredStyle: .alert)
        var inputTextField: UITextField?
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Subject ID"
            inputTextField = textField
            textField.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        let action = UIAlertAction(title: "Ok", style: .default){ _ in
            self.addWaterMark(name: (inputTextField?.text)!)
            self.nameLabel.textAlignment = .center
            self.nameLabel.center.x = self.nameLabel.frame.maxX
            self.subjectID = (inputTextField?.text)!
            self.currentSession = Session(currentSubjectId: (self.subjectID + "." + self.backImageName))
            self.currentSession.boxAuthorize()
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
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
        
        
        tempImageView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        if !customViewActive() {
            createCustomViewUpdate(frame: CGRect(x: touchPoint.x - 100, y: touchPoint.y - 100, width: 200, height: 200))
        }
        //createGreyView(frame: CGRect(x: touchPoint.x - 100, y: touchPoint.y - 100, width: 200, height: 200))
    }
    
    func createGreyView(frame: CGRect){
        
        let c = CustomGreyView(frame: frame)
        
        mainImgView.addSubview(c)
    }
    
    func createCustomViewUpdate(frame: CGRect){

        intSlider.setValue(5, animated: false)
        greySlider.setValue(0, animated: false)
        blackSlider.setValue(0, animated: false)
        let c = CustomViewUpdate(frame: frame)
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTapUpdate))
        c.addGestureRecognizer(gestureTap)
        c.layer.zPosition = 2
        c.blur.blurRadius = 5
        //mainImgView.addSubview(c)
        mainImgView.insertSubview(c, aboveSubview: mainImgView)
        customViewUpdateList.append(c)

        if isGridHidden {
            c.valueLabel.alpha = 0
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

//MARK: work in progress


//var changeBackgroundView : UIView = {
//   let temp = UIView()
//    temp.backgroundColor = .black
//    temp.backgroundColor?.withAlphaComponent(0.5)
//    
//    
//    
//    return temp
//}()

enum ControlState {
    case Disable, OnlyBlur, BlurAndAlpha, Black
}