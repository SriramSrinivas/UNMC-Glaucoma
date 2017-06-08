import UIKit

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    var bckImage = UIImage()
    
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
    var customViewList = [CustomView]()
    var customObjectList = [CustomObject]()
    var currView = CustomView()
    var tempImageView = UIView()
    var iterVal = 0
    
    let delete = UIButton()
    var hideImageText = UILabel()
    var hideImageButton = UISwitch()
    var isHideMode: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
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
        //addHideImageButton(sideView: sideView)
        addBlurButton()
        
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
    
    func addHideImageButton(sideView: UIView){
        hideImageButton.frame = CGRect(x: 20, y: sideView.frame.height - 300, width: 100, height: 50)
        hideImageButton.addTarget(self, action: #selector(hideButtonTap), for: .valueChanged)
        sideView.addSubview(hideImageButton)
        hideImageButton.setOn(true, animated: false)
        hideImageButton.isHidden = true
        
        hideImageText.frame = CGRect(x: 90, y: sideView.frame.height - 300, width: 100, height: 50)
        hideImageText.text = "Hide"
        hideImageText.textColor = UIColor(hexString: "EEEEEE")
        sideView.addSubview(hideImageText)
        hideImageText.isHidden = true
    }
    
    
    func addBlurButton(){
        
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
            for i in customViewList {
                i.isHidden = true
            }
        case false:
            for i in customViewList {
                i.isHidden = false
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
        
        if currView.editMode == true {
            currView.blur.blurRadius = CGFloat(value)
        }
    }
    
    func sliderAlpha(slider: UISlider){
        var value = slider.value
        value = value/10
        
        tempImageView.alpha = CGFloat(value)
    }
    
    func imgPanHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        
                    if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                        let translation = gestureRecognizer.translation(in: self.view)
                        gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                    }
    }
    
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.view is CustomView {
            let temp = gestureRecognizer.view as! CustomView
            if temp.editMode {
                if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                    let translation = gestureRecognizer.translation(in: self.view)
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                    gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                }
            }
        }
    }
    
    func handleCustomObjectTap(sender: UITapGestureRecognizer){
        print("Object tapped")
        
        isHideMode = true
        
        for i in customViewList {
            if i.customViewID == currView.customViewID {
                i.selected(isSelected: false)
                i.editMode = false
            }
        }
        
        for i in customObjectList {
            if (sender.view == i) {
                print("Custom Object match found")
                createCustomView(xTouchPoint: i.frame.origin.x, yTouchPoint: i.frame.origin.y, width: 200, height: 200, color: "3F51B5")
                tempImageView = i
            }
        }
    }

    func handleCustomViewTap(_ gestureRecognizer: UITapGestureRecognizer){
        
        //controlStack.isHidden = false
        enableControl(value: true)
        for i in customViewList {
            if i.customViewID != currView.customViewID {
                i.selected(isSelected: false)
                i.editMode = false
                isHideMode = true
            }
        }
        currView.selected(isSelected: true)
        currView.editMode = true
        intSlider.setValue(Float(currView.blur.blurRadius), animated: true)
    }
    
    func handlePinchZoom(_ gestureRecognizer: UIPinchGestureRecognizer){
        
        if((gestureRecognizer.view as! CustomView) == currView) {
            currView.frame.size.height = 200*(gestureRecognizer.scale)
            currView.frame.size.width = 200*(gestureRecognizer.scale)
            currView.blur.frame.size.height = 200*(gestureRecognizer.scale)
            currView.blur.frame.size.width = 200*(gestureRecognizer.scale)
        }
    }
    
    func cancelTap(sender: UIButton!){
        //editMode = false
        currView.selected(isSelected: false)
        currView.editMode = false
        controlStack.isHidden = true
        
        var iter = 0
        for i in customViewList {
            iter += 1
            if currView.customViewID == i.customViewID {
                customViewList = customViewList.filter() { $0 != i }
            }
        }
        currView.removeFromSuperview()
        enableControl(value: false)
        isHideMode = false
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
        
        tempImageView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        
        if(!isHideMode) {
            createCustomView(xTouchPoint: touchPoint.x, yTouchPoint: touchPoint.y, width: 200, height: 200, color: "F44556")
            isHideMode = true
        
            for i in customViewList {
                if i.customViewID != currView.customViewID {
                    i.selected(isSelected: false)
                    i.editMode = false
                }
            }
        } else {
            
            for i in customViewList {
                if i.customViewID == currView.customViewID {
                    i.selected(isSelected: false)
                    i.editMode = false
                }
            }
            
            hideImageButton.isHidden = true
            hideImageText.isHidden = true
            isHideMode = false
            enableControl(value: false)
        }
    }
    
    func createCustomView(xTouchPoint: CGFloat, yTouchPoint: CGFloat, width: CGFloat, height: CGFloat, color: String){
        
        enableControl(value: true)
        
        intSlider.setValue(0, animated: false)
    
        let c = CustomView(frame: CGRect(x: xTouchPoint, y: yTouchPoint, width: width, height: width))
        c.customViewID = iterVal
        c.selected(isSelected: true)
        c.editMode = true
        c.setBlurColor(color: color)

        iterVal += 1
        customViewList.append(c)
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        c.addGestureRecognizer(gestureRecognizer1)
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(handleCustomViewTap))
        c.addGestureRecognizer(gestureTap)
        let pinchZoom = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchZoom))
        c.addGestureRecognizer(pinchZoom)
        
        view.addSubview(c)
        currView = c
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
