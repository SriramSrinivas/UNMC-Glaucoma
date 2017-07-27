import UIKit
import RealmSwift
import VisualEffectView

class ViewController: UIViewController{
        
    let screenSize: CGRect = UIScreen.main.bounds
    var bckImage = UIImage()
    var mainImgView = UIView()
    var nameView = UIView()
    
    var blurOnIcon = UIImageView()
    var blurOffIcon = UIImageView()
    var sightOnIcon = UIImageView()
    var sightOffIcon = UIImageView()
    var sunIcon = UIImageView()
    
    let export = UIButton()

    let toggleStack = UIStackView()
    let sliderStack = UIStackView()

    var gridViews = [UIView]()
    
    let intSlider = UISlider()
    let intText = UILabel()
    let alphSlider = UISlider()
    let greySlider = UISlider()
    let alphaToggle = UISwitch()
    let luminText = UILabel()
    var customObjectList = [CustomObject]()
    var tempImageView = UIView()
    var iterVal = 0
    
    var customViewUpdateList = [CustomViewUpdate]()
    
    let delete = UIButton()
    
    let tempBlur = VisualEffectView()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

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

        initToggle(sideView: sideView)
        addExportButton(view: sideView)
        addControlIcons()
        addSlider(view: sideView)
        initCustomObjects()
        addGridLineUpdate(mainView: mainImgView)
        

        addGridPoints(view: mainImgView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        enterNameDialog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initToggle(sideView: UIView){
        
        let gridHeight = sideView.frame.size.height*0.65
        let origHeight = sideView.frame.size.height*0.75
    
        let gridSwitch = UISwitch()
        gridSwitch.frame = CGRect(x: 30, y: gridHeight, width: 50, height: 100)
        gridSwitch.isOn = true
        gridSwitch.addTarget(self, action: #selector(toggleGrid), for: UIControlEvents.valueChanged)
        
        let origSwitch = UISwitch()
        origSwitch.frame = CGRect(x: 30, y: origHeight, width: 50, height: 100)
        origSwitch.addTarget(self, action: #selector(toggleOriginal), for: UIControlEvents.valueChanged)
        
        let gridText = UILabel()
        gridText.frame = CGRect(x: 100, y: gridHeight, width: 150, height: 50)
        gridText.text = "Grid"
        gridText.textColor = UIColor.white
        
        let origText = UILabel()
        origText.frame = CGRect(x: 100, y: origHeight, width: 150, height: 50)
        origText.text = "Original"
        origText.textColor = UIColor.white
        
        sideView.addSubview(gridSwitch)
        sideView.addSubview(origSwitch)
        sideView.addSubview(gridText)
        sideView.addSubview(origText)
    }
    
    func loadImage(mainImgView: UIView){

        let image = UIImage(named: "mainTes")
        bckImage = image!
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        imageView.image = image
        mainImgView.addSubview(imageView)
    }

    func addSlider(view: UIView){
        
        blurOnIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        blurOnIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        blurOffIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        blurOffIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        sightOnIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sightOnIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        sightOffIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sightOffIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        sunIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sunIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true

        intText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intText.widthAnchor.constraint(equalToConstant: 20).isActive = true
        intText.text = "Blur"
        intText.textColor = UIColor.white
        
        luminText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        luminText.widthAnchor.constraint(equalToConstant: 50).isActive = true
        luminText.text = "Luminosity"
        
        delete.setTitle("Reset", for: UIControlState.normal)
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

        intSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        intSlider.addTarget(self, action: #selector(sliderIntensity), for: UIControlEvents.valueChanged)
        intSlider.minimumValue = 0
        intSlider.maximumValue = 10
        intSlider.setValue(0, animated: false)
        
        greySlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        greySlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        greySlider.addTarget(self, action: #selector(sliderGrey), for: UIControlEvents.valueChanged)
        greySlider.minimumValue = 0
        greySlider.maximumValue = 10
        greySlider.setValue(0, animated: false)
        
        alphSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        alphSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        alphSlider.addTarget(self, action: #selector(sliderAlpha), for: UIControlEvents.valueChanged)
        alphSlider.minimumValue = 0
        alphSlider.maximumValue = 10
        alphSlider.setValue(10, animated: false)

        sliderStack.axis = UILayoutConstraintAxis.vertical
        sliderStack.distribution = UIStackViewDistribution.equalSpacing
        sliderStack.alignment = UIStackViewAlignment.center
        sliderStack.spacing = 5.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

        sliderStack.addArrangedSubview(blurOnIcon)
        sliderStack.addArrangedSubview(blurOffIcon)
        sliderStack.addArrangedSubview(intSlider)
        sliderStack.addArrangedSubview(tempView)
        sliderStack.addArrangedSubview(sunIcon)
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

        export.setTitle("Export", for: UIControlState.normal)
        export.heightAnchor.constraint(equalToConstant: 50).isActive = true
        export.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        export.backgroundColor = UIColor(hexString: "#0D47A1")
        export.addTarget(self, action: #selector(exportTap), for: .touchUpInside)
        
        clear.setTitle("Start Over", for: UIControlState.normal)
        clear.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clear.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        clear.backgroundColor = UIColor(hexString: "#1B5E20")
        clear.addTarget(self, action: #selector(clearTap), for: .touchUpInside)
        
        stack.axis = UILayoutConstraintAxis.vertical
        stack.distribution = UIStackViewDistribution.equalSpacing
        stack.alignment = UIStackViewAlignment.center
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(clear)
        stack.addArrangedSubview(export)
        
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
            
            mainImgView.addSubview(i)
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
        sunIcon = tempImage("sun", sunIcon)
    }
    
    func initCustomObjects(){
        
        customObjectList = [CustomObject(imageName: "doggo", xPos: 413, yPos: 413, sideSize: 90, alphaValue: 1),
                                             CustomObject(imageName: "trashcan", xPos: -21, yPos: 366, sideSize: 130, alphaValue: 1),
                                             CustomObject(imageName: "cone", xPos: 122, yPos: 361, sideSize: 60, alphaValue: 1),
                                             CustomObject(imageName: "cone", xPos: 185, yPos: 325.5, sideSize: 60, alphaValue: 1),
                                             CustomObject(imageName: "ball", xPos: 575.5, yPos: 385, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "kid1", xPos: 380, yPos: 279.5, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "kid2", xPos: 423.5, yPos: 271, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "peel", xPos: 55.5, yPos: 460.5, sideSize: 65, alphaValue: 1),
                                             CustomObject(imageName: "helmet", xPos: 176.5, yPos: 387, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "girl", xPos: 735, yPos: 237.6, sideSize: 230, alphaValue: 1),
                                             CustomObject(imageName: "hydrant", xPos: 606, yPos: 300, sideSize: 70, alphaValue: 1)]

        
        for i in customObjectList {
            i.isUserInteractionEnabled = true
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleCustomObjectTap))
            i.addGestureRecognizer(gestureTap)

            mainImgView.addSubview(i)
        }
    }
    

    func toggleGrid(mySwitch: UISwitch) {
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
    
    func toggleOriginal(mySwitch: UISwitch) {
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
            //customViewList.removeLast()
            //currView.removeFromSuperview()
        case true:
            tempImageView.isHidden = false
        default: break
        }
    }
    
    func sliderIntensity(slider: UISlider){
        let value = slider.value
        
        for i in customViewUpdateList {
            if i.isActive {
                i.blur.blurRadius = CGFloat(value)
                i.blur.backgroundColor = UIColor.clear
                i.blur.alpha = 1
                greySlider.setValue(0, animated: false)
            }
        }
    }
    
    func sliderAlpha(slider: UISlider){
        var value = slider.value
        value = value/10
        let temp = getCurrentActiveView()
        temp.linkedImage.alpha = CGFloat(value)
        temp.alphaValue = CGFloat(value*10)
    }
    
    func sliderGrey(slider: UISlider){
        var value = slider.value
        value = value/10
        //value = 10 - value
        print("Grey sLider : \(value)")
        let temp = getCurrentActiveView()
        temp.blur.backgroundColor = UIColor.black
        temp.blur.alpha = CGFloat(value)
        
        temp.blur.blurRadius = 0
        intSlider.setValue(0, animated: false)
    }
    
    func switchAlpha(sender: UISwitch!){
        
        let temp = getCurrentActiveView()
        
        switch sender.isOn {
        case true:
                temp.linkedImage.alpha = 1
                temp.alphaValue = 1
        case false:
                temp.linkedImage.alpha = 0
                temp.alphaValue = 0
        }
    }

    func handleCustomObjectTap(sender: UITapGestureRecognizer){
        
        //alphSlider.setValue(10, animated: false)
        alphaToggle.isOn = true
        
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
    
    func handleTapUpdate(sender: UITapGestureRecognizer){
        
        let temp = sender.view as! CustomViewUpdate
        
        for i in customViewUpdateList {
            if i != temp {
                i.isActive(value: false)
            }
            else {
                i.isActive(value: true)
                intSlider.setValue(Float(i.blur.blurRadius), animated: false)
                
                if i.isLinkedToImage{
                    //alphSlider.setValue(Float(i.alphaValue), animated: false)
                    print("Alpha Value of image : \(i.alphaValue)")
                    if (i.alphaValue == 0){
                        alphaToggle.setOn(false, animated: false)
                    } else {
                        alphaToggle.setOn(true, animated: false)
                    }
                    enableControl(value: .BlurAndAlpha)
                } else {
                    enableControl(value: .OnlyBlur)
                }
            }
        }
    }
    
    func resetTap(sender: UIButton!){
        
        let temp = getCurrentActiveView()
        if temp.isLinkedToImage {
            temp.linkedImage.alpha = 1
        }
        customViewUpdateList = customViewUpdateList.filter() { $0 != temp }
        temp.removeFromSuperview()
        enableControl(value: .Disable)
    }
    
    func clearTap(sender: UIButton!){
        
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
        for i in patients {
            print("Stored Patient: \(i.name)")
        }
    }
    
    func exportTap(sender: UIButton!){
    
        takeScreenShot()
        
        let okAlert = UIAlertController(title: "Image was saved", message: "Image was stored in the Photo Gallery", preferredStyle: .alert)
        let action2 = UIAlertAction(title: "Close", style: .default) { _ in
        }
        
        okAlert.addAction(action2)
        
        self.present(okAlert, animated: true)
    }
    
    func enterNameDialog(){
        
        let alert = UIAlertController(title: "Enter Subject Identifier", message: "", preferredStyle: .alert)
        var inputTextField: UITextField?
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Subject ID"
            inputTextField = textField
        }
        
        let action = UIAlertAction(title: "Ok", style: .default){ _ in
            
            self.addWaterMark(name: (inputTextField?.text)!)
            
            let patient = PatientData()
            patient.age = 10
            patient.name = "Ram"
            
            
        }
        
        alert.addAction(action)
        
        self.present(alert,animated: true)
    }
    
    func addWaterMark(name: String){

        
        nameView.frame = CGRect(x: 0, y: mainImgView.frame.height - 15, width: mainImgView.frame.width, height: 15)
        nameView.backgroundColor = UIColor(hexString: "000000")
        
        let nameLabel = UILabel(frame: CGRect(x: nameView.frame.width/2, y: 0, width: 200, height: 15))
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

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
        
        tempImageView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        createCustomViewUpdate(frame: CGRect(x: touchPoint.x - 100, y: touchPoint.y - 100, width: 200, height: 200))
        //createGreyView(frame: CGRect(x: touchPoint.x - 100, y: touchPoint.y - 100, width: 200, height: 200))
    }
    
    func createGreyView(frame: CGRect){
        
        let c = CustomGreyView(frame: frame)
        
        mainImgView.addSubview(c)
    }
    
    func createCustomViewUpdate(frame: CGRect){
        
        var activatedViews: Bool = false
        
        intSlider.setValue(5, animated: false)
        
        for i in customViewUpdateList{
            if i.isActive {
                i.isActive(value: false)
                activatedViews = true
            }
        }
        
        if !activatedViews{
            
            enableControl(value: .OnlyBlur)
            
            let c = CustomViewUpdate(frame: frame)
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTapUpdate))
            c.addGestureRecognizer(gestureTap)
            c.layer.zPosition = 2
            c.blur.blurRadius = 5
            mainImgView.addSubview(c)
            customViewUpdateList.append(c)
            
            print("c z axis : \(c.layer.zPosition)")
        } else {
            enableControl(value: .Disable)
        }
    }
    
    /*func createCustomViewUpdate(frame: CGRect){
        
        let c = CustomGreyView(frame: frame)
        mainImgView.addSubview(c)
    }*/
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
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
    
    func takeScreenShot() {
        //Create the UIImage
        UIGraphicsBeginImageContext(mainImgView.frame.size)
        //mainImgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        mainImgView.drawHierarchy(in: mainImgView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
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
        
        let width = view.frame.width/2
        var initWidth = width/8
        
        for _ in 1...8{
            
            let c = CustomPoint(xPos: initWidth, yPos: view.frame.height/2)
            c.backgroundColor = UIColor.red
            view.addSubview(c)
            
            initWidth = initWidth + width/8
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
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    func enableControl(value: ControlState){
        switch value {
        case .BlurAndAlpha:
            
            intText.textColor = UIColor(hexString: "EEEEEE")
            intText.alpha = 1
            intSlider.tintColor = UIColor(hexString: "EEEEEE")
            intSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            alphSlider.tintColor = UIColor(hexString: "EEEEEE")
            alphSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            delete.alpha = 1
            delete.isEnabled =  true
            
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
            
            sunIcon.alpha = 1
            
        case .Disable:
            
            intText.textColor = UIColor(hexString: "9E9E9E")
            intText.alpha = 0.4
            intSlider.tintColor = UIColor(hexString: "9E9E9E")
            intSlider.thumbTintColor = UIColor(hexString: "9E9E9E")
            intSlider.alpha = 0.4
            
            alphSlider.tintColor = UIColor(hexString: "9E9E9E")
            alphSlider.thumbTintColor = UIColor(hexString: "9E9E9E")
            alphSlider.alpha = 0.4
            
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
            
            sunIcon.alpha = 0.4
            
        case .OnlyBlur:
            
            intText.textColor = UIColor(hexString: "EEEEEE")
            intText.alpha = 1
            intSlider.tintColor = UIColor(hexString: "EEEEEE")
            intSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
        
            delete.alpha = 1
            delete.isEnabled =  true
            
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
            
            sunIcon.alpha = 1

        default:
            break
        }
    }
}

enum ControlState {
    case Disable, OnlyBlur, BlurAndAlpha
}
