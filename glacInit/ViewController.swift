import UIKit

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    var bckImage = UIImage()
    var mainImgView = UIView()
    
    var blurOnIcon = UIImageView()
    var blurOffIcon = UIImageView()
    var sightOnIcon = UIImageView()
    var sightOffIcon = UIImageView()

    let controlStack = UIStackView()
    let toggleStack = UIStackView()
    let sliderStack = UIStackView()

    var gridViews = [UIView]()
    var tBlurInt = CGFloat()
    
    let intSlider = UISlider()
    let intText = UILabel()
    let alphSlider = UISlider()
    var customObjectList = [CustomObject]()
    var tempImageView = UIView()
    var iterVal = 0
    
    var customViewUpdateList = [CustomViewUpdate]()
    
    let delete = UIButton()
    let export = UIButton()
    
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
        addControlIcons()
        addSlider(view: sideView)
        addGridLineUpdate(mainView: mainImgView)
        
        initCustomObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initToggle(sideView: UIView){
        
        let gridHeight = sideView.frame.size.height*0.75
        let origHeight = sideView.frame.size.height*0.85
    
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

        intText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intText.widthAnchor.constraint(equalToConstant: 20).isActive = true
        intText.text = "Blur"
        intText.textColor = UIColor.white
        
        delete.setTitle("Delete", for: UIControlState.normal)
        delete.heightAnchor.constraint(equalToConstant: 50).isActive = true
        delete.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        delete.backgroundColor = UIColor(hexString: "#f44336")
        delete.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
        
        export.setTitle("Export", for: UIControlState.normal)
        export.heightAnchor.constraint(equalToConstant: 50).isActive = true
        export.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        export.backgroundColor = UIColor(hexString: "#0D47A1")
        export.addTarget(self, action: #selector(exportTap), for: .touchUpInside)
        
        let tempView = UIButton()
        tempView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tempView.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        tempView.backgroundColor = UIColor(hexString: "#424242")
        
        let tempView1 = UIButton()
        tempView1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tempView1.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        tempView1.backgroundColor = UIColor(hexString: "#424242")

        intSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        intSlider.addTarget(self, action: #selector(sliderIntensity), for: UIControlEvents.valueChanged)
        intSlider.minimumValue = 0
        intSlider.maximumValue = 10
        intSlider.setValue(0, animated: false)
        
        alphSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        alphSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        alphSlider.addTarget(self, action: #selector(sliderAlpha), for: UIControlEvents.valueChanged)
        alphSlider.minimumValue = 0
        alphSlider.maximumValue = 10
        alphSlider.setValue(10, animated: false)

        sliderStack.axis = UILayoutConstraintAxis.vertical
        sliderStack.distribution = UIStackViewDistribution.equalSpacing
        sliderStack.alignment = UIStackViewAlignment.center
        sliderStack.spacing = 10.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

        sliderStack.addArrangedSubview(blurOnIcon)
        sliderStack.addArrangedSubview(blurOffIcon)
        sliderStack.addArrangedSubview(intSlider)
        sliderStack.addArrangedSubview(tempView)
        sliderStack.addArrangedSubview(sightOnIcon)
        sliderStack.addArrangedSubview(sightOffIcon)
        sliderStack.addArrangedSubview(alphSlider)
        sliderStack.addArrangedSubview(tempView1)
        sliderStack.addArrangedSubview(delete)
        sliderStack.addArrangedSubview(export)

        view.addSubview(sliderStack)

        sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        enableControl(value: false)
    }

    func addGridLineUpdate(mainView: UIView){

        let line1 = UIButton()
        line1.frame = CGRect(x: mainView.frame.width*0.3, y: 0, width: 5, height: mainView.frame.height)
        line1.layer.borderWidth = 5
        line1.layer.borderColor = UIColor(hexString: "FF9800").cgColor

        let line2 = UIButton()
        line2.frame = CGRect(x: mainView.frame.width*0.66, y: 0, width: 5, height: mainView.frame.height)
        line2.layer.borderWidth = 5
        line2.layer.borderColor = UIColor(hexString: "FF9800").cgColor

        let line3 = UIButton()
        line3.frame = CGRect(x: 0, y: mainView.frame.height*0.5, width: mainView.frame.width, height: 5)
        line3.layer.borderWidth = 5
        line3.layer.borderColor = UIColor(hexString: "FF9800").cgColor

        gridViews.append(line1)
        gridViews.append(line2)
        gridViews.append(line3)

        for i in gridViews {
            mainView.addSubview(i)
        }
    }
    
    func addControlIcons(){
        
        let image = UIImage(named: "BlurOn")
        let image2 = UIImage(named: "BlurOff")
        let image3 = UIImage(named: "SightOn")
        let image4 = UIImage(named: "SightOff")

        blurOnIcon = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        blurOnIcon.image = image
        blurOffIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: (image2?.size.width)!, height: (image2?.size.height)!))
        blurOffIcon.image = image2
        sightOnIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: (image3?.size.width)!, height: (image3?.size.height)!))
        sightOnIcon.image = image3
        sightOffIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: (image4?.size.width)!, height: (image4?.size.height)!))
        sightOffIcon.image = image4
    }
    
    func initCustomObjects(){
        
        customObjectList = [CustomObject(imageName: "doggo", xPos: 413, yPos: 413, sideSize: 90, alphaValue: 1),
                                             CustomObject(imageName: "trashcan", xPos: -21, yPos: 366, sideSize: 130, alphaValue: 1),
                                             CustomObject(imageName: "cone", xPos: 122, yPos: 361, sideSize: 60, alphaValue: 1),
                                             CustomObject(imageName: "cone", xPos: 185, yPos: 325.5, sideSize: 60, alphaValue: 1),
                                             CustomObject(imageName: "ball", xPos: 575.5, yPos: 385, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "kid1", xPos: 380, yPos: 279.5, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "kid1", xPos: 423.5, yPos: 271, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "peel", xPos: 55.5, yPos: 460.5, sideSize: 65, alphaValue: 1),
                                             CustomObject(imageName: "helmet", xPos: 176.5, yPos: 387, sideSize: 50, alphaValue: 1),
                                             CustomObject(imageName: "girl", xPos: 735, yPos: 237.6, sideSize: 230, alphaValue: 1),
                                             CustomObject(imageName: "hydrant", xPos: 606, yPos: 300, sideSize: 70, alphaValue: 1)]

        
        for i in customObjectList {
            i.isUserInteractionEnabled = true
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleCustomObjectTap))
            i.addGestureRecognizer(gestureTap)

            view.addSubview(i)
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
            for i in customViewUpdateList {
                i.isHidden = true
                mainImgView.isUserInteractionEnabled = false
            }
        case false:
            for i in customViewUpdateList {
                i.isHidden = false
                mainImgView.isUserInteractionEnabled = true
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
            }
        }
    }
    
    func sliderAlpha(slider: UISlider){
        var value = slider.value
        value = value/10
        
        tempImageView.alpha = CGFloat(value)
    }

    
    func handleCustomObjectTap(sender: UITapGestureRecognizer){
        print("Object tapped")
        
        for i in customObjectList {
            if (sender.view == i) {
                print("Custom Object match found")
                //createCustomView(xTouchPoint: i.frame.origin.x, yTouchPoint: i.frame.origin.y, width: 200, height: 200, color: "3F51B5")
                tempImageView = i
            }
        }
    }
    
    func handleTapUpdate(sender: UITapGestureRecognizer){
        
        enableControl(value: true)
        
        let temp = sender.view as! CustomViewUpdate
        temp.handleTap(sender: sender)
        
        print("Tap Update")
        
        for i in customViewUpdateList {
            if i != temp {
                i.isActive(value: false)
            }
            else {
                i.isActive(value: true)
                intSlider.setValue(Float(i.blur.blurRadius), animated: false)
            }
        }
    }
    
    func cancelTap(sender: UIButton!){
        
        for i in customViewUpdateList {
            if i.isActive{
                customViewUpdateList = customViewUpdateList.filter() { $0 != i }
                i.removeFromSuperview()
            }
        }
        
        enableControl(value: false)
    }
    
    func exportTap(sender: UIButton!){
        takeScreenShot()
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
        
        tempImageView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        createCustomViewUpdate(frame: CGRect(x: touchPoint.x, y: touchPoint.y, width: 200, height: 200))
    }
    
    func createCustomViewUpdate(frame: CGRect){
        
        var activatedViews: Bool = false
        
        intSlider.setValue(0, animated: false)
        
        for i in customViewUpdateList{
            if i.isActive {
                i.isActive(value: false)
                activatedViews = true
            }
        }
        
        if !activatedViews{
            
            enableControl(value: true)
            
            let c = CustomViewUpdate(frame: frame)
            let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleTapUpdate))
            c.addGestureRecognizer(gestureTap)
            view.addSubview(c)
            customViewUpdateList.append(c)
        } else {
            enableControl(value: false)
        }
    }
    
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
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func enableControl(value: Bool){
        switch value {
        case false:
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
            
        case true:
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
            
        default:
            break
        }
    }
}
