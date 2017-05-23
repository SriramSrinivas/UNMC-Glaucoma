import UIKit
import VisualEffectView

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    let blur = VisualEffectView()
    let blurButton = UIButton()
    var isBlur: Bool = false
    let tempFrame = UIView()
    let tempFrameColor = UIView()
    var bckImage = UIImage()
    
    let doggoImage = UIView()
    let trashImage = UIView()
    let coneImage = UIView()
    let coneImage2 = UIView()
    let ballImage = UIView()
    let kid1Image = UIView()
    let kid2Image = UIView()
    let peelImage = UIView()
    let helmetImage = UIView()
    let girlImage = UIView()

    let controlStack = UIStackView()
    let toggleStack = UIStackView()
    let sliderStack = UIStackView()

    var gridViews = [UIView]()
    var tBlurInt = CGFloat()
    
    let intSlider = UISlider()
    let intText = UILabel()
    var customViewList = [CustomView]()
    var currView = CustomView()
    var tempImageView = UIView()
    var iterVal = 0
    let delete = UIButton()
    
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
        addHideImageButton(sideView: sideView)
        
        addSlider(view: sideView)

        addGridLineUpdate(mainView: mainImgView)
        
        addDoggo()
        addTrash()
        addCone()
        addCone2()
        addBall()
        addKid1()
        addKid2()
        addPeel()
        addGirl()
        addHelmet()
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
    
    func addBlur(xLoc: CGFloat, yLoc: CGFloat){
        
        tempFrameColor.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    

        blur.frame = CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 100, height: 100)
        blur.layer.borderWidth = 5
        blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
        blur.layer.cornerRadius = 50
        blur.blurRadius = 10
        tBlurInt = blur.blurRadius

        blur.isHidden = false

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        blur.addGestureRecognizer(gestureRecognizer)

        self.view.addSubview(blur)
    }

    func loadImage(mainImgView: UIView){

        let image = UIImage(named: "mainTes")
        bckImage = image!
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        imageView.image = image
        mainImgView.addSubview(imageView)

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        blur.addGestureRecognizer(gestureRecognizer)
    }

    func addSlider(view: UIView){

        intText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        intText.text = "Blur Intensity"
        intText.textColor = UIColor.white
        
        delete.setTitle("Delete", for: UIControlState.normal)
        delete.heightAnchor.constraint(equalToConstant: 50).isActive = true
        delete.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        delete.backgroundColor = UIColor(hexString: "#f44336")
        delete.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)

        intSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        intSlider.addTarget(self, action: #selector(sliderIntensity), for: UIControlEvents.valueChanged)
        intSlider.minimumValue = 1
        intSlider.maximumValue = 10
        intSlider.setValue(10, animated: false)

        sliderStack.axis = UILayoutConstraintAxis.vertical
        sliderStack.distribution = UIStackViewDistribution.equalSpacing
        sliderStack.alignment = UIStackViewAlignment.center
        sliderStack.spacing = 10.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

        sliderStack.addArrangedSubview(intText)
        sliderStack.addArrangedSubview(intSlider)
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
        line1.layer.borderColor = UIColor.red.cgColor

        let line2 = UIButton()
        line2.frame = CGRect(x: mainView.frame.width*0.66, y: 0, width: 5, height: mainView.frame.height)
        line2.layer.borderWidth = 5
        line2.layer.borderColor = UIColor.red.cgColor

        let line3 = UIButton()
        line3.frame = CGRect(x: 0, y: mainView.frame.height*0.5, width: mainView.frame.width, height: 5)
        line3.layer.borderWidth = 5
        line3.layer.borderColor = UIColor.red.cgColor

        gridViews.append(line1)
        gridViews.append(line2)
        gridViews.append(line3)

        for i in gridViews {
            mainView.addSubview(i)
        }
    }
    
    func addHideImageButton(sideView: UIView){
        hideImageButton.frame = CGRect(x: 20, y: sideView.frame.height - 300, width: 100, height: 50)
        hideImageButton.backgroundColor = UIColor(hexString: "#F44556")
        hideImageButton.addTarget(self, action: #selector(hideButtonTap), for: .valueChanged)
        sideView.addSubview(hideImageButton)
        
        hideImageButton.isHidden = true
    }
    
    func addDoggo(){
        
        var image = UIImage(named: "doggo")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 90, height: 90))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        doggoImage.frame = CGRect(x: 413, y: 413, width: imageView.frame.size.width, height: imageView.frame.size.height)
        doggoImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(doggoTap))
        doggoImage.addGestureRecognizer(gestureRecognizer1)
        
        view.addSubview(doggoImage)
        
        for i in gridViews {
            doggoImage.sendSubview(toBack: i)
        }
    }
    
    func addTrash(){
        
        var image = UIImage(named: "trashcan")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 130, height: 130))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        for i in gridViews {
            imageView.sendSubview(toBack: i)
        }
        
        trashImage.frame = CGRect(x: -21, y: 366, width: imageView.frame.size.width, height: imageView.frame.size.height)
        trashImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(trashTap))
        trashImage.addGestureRecognizer(gestureRecognizer1)
        
        view.addSubview(trashImage)
        
        for i in gridViews {
            trashImage.sendSubview(toBack: i)
        }
    }
    
    func addCone(){
        var image = UIImage(named: "cone")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 60, height: 60))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        coneImage.frame = CGRect(x: 122, y: 361, width: imageView.frame.size.width, height: imageView.frame.size.height)
        coneImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(coneTap))
        coneImage.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //coneImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(coneImage)
    }
    
    func addCone2(){
        var image = UIImage(named: "cone")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 60, height: 60))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        coneImage2.frame = CGRect(x: 185, y: 325.5, width: imageView.frame.size.width, height: imageView.frame.size.height)
        coneImage2.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(cone2Tap))
        coneImage2.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //coneImage2.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(coneImage2)
    }
    
    func addBall(){
        var image = UIImage(named: "ball")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 50, height: 50))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        ballImage.frame = CGRect(x: 575.5, y: 385, width: imageView.frame.size.width, height: imageView.frame.size.height)
        ballImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(ballTap))
        ballImage.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //ballImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(ballImage)
    }
    
    func addKid1(){
        var image = UIImage(named: "kid1")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 50, height: 50))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        kid1Image.frame = CGRect(x: 380, y: 279.5, width: imageView.frame.size.width, height: imageView.frame.size.height)
        kid1Image.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(kid1Tap))
        kid1Image.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //kid1Image.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(kid1Image)
    }
    
    func addKid2(){
        var image = UIImage(named: "kid1")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 50, height: 50))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        kid2Image.frame = CGRect(x: 423.5, y: 271, width: imageView.frame.size.width, height: imageView.frame.size.height)
        kid2Image.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(kid2Tap))
        kid2Image.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //kid2Image.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(kid2Image)
    }
    
    func addPeel(){
        var image = UIImage(named: "peel")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 50, height: 50))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        peelImage.frame = CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height)
        peelImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(peelTap))
        peelImage.addGestureRecognizer(gestureRecognizer1)
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        peelImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(peelImage)
    }
    
    func addHelmet(){
        var image = UIImage(named: "helmet")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 50, height: 50))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        helmetImage.frame = CGRect(x: 176.5, y: 387, width: imageView.frame.size.width, height: imageView.frame.size.height)
        helmetImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(helmetTap))
        helmetImage.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //helmetImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(helmetImage)
    }
    
    func addGirl(){
        var image = UIImage(named: "girl")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 230, height: 230))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        girlImage.frame = CGRect(x: 735, y: 237.6, width: imageView.frame.size.width, height: imageView.frame.size.height)
        girlImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(girlTap))
        girlImage.addGestureRecognizer(gestureRecognizer1)
        //let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imgPanHandler))
        //girlImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(girlImage)
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
    
    func doggoTap(sender: UITapGestureRecognizer!){
        print("Tap Doggo")
        createCustomView(xTouchPoint: 413, yTouchPoint: 413, width: 90, height: 90)
        
        isHideMode = true
        hideImageButton.isHidden = false
        tempImageView = doggoImage
    }
    
    func trashTap(sender: UITapGestureRecognizer!){
        print("Tap Trash")
    }
    
    func coneTap(sender: UITapGestureRecognizer!){
        print("Location : \(coneImage.frame.origin)")
    }
    
    func cone2Tap(sender: UITapGestureRecognizer!){
        print("Location : \(coneImage2.frame.origin)")
    }
    
    func ballTap(sender: UITapGestureRecognizer!){
        print("Location : \(ballImage.frame.origin)")
    }
    
    func kid1Tap(sender: UITapGestureRecognizer!){
        print("Location : \(kid1Image.frame.origin)")
    }
    
    func kid2Tap(sender: UITapGestureRecognizer!){
        print("Location : \(kid2Image.frame.origin)")
    }
    
    func peelTap(sender: UITapGestureRecognizer!){
        print("Location peel : \(peelImage.frame.origin)")
    }
    
    func helmetTap(sender: UITapGestureRecognizer!){
        print("Location helmet : \(helmetImage.frame.origin)")
    }
    
    func girlTap(sender: UITapGestureRecognizer!){
        print("Location girl : \(girlImage.frame.origin)")
    }
    
    func hideButtonTap(mySwitch: UISwitch!){
        
        let value = mySwitch.isOn
        
        switch value {
        case true:
            tempImageView.isHidden = true
            //customViewList.removeLast()
            //currView.removeFromSuperview()
        case false:
            tempImageView.isHidden = false
        default: break
        }
    }

    func sliderSize(slider: UISlider){
        let value = slider.value

        print("Value : \(value)")
        
        blur.frame.size.height = 100*CGFloat(value)
        blur.frame.size.width = 100*CGFloat(value)
    }
    
    func sliderIntensity(slider: UISlider){
        let value = slider.value
        
        if currView.editMode == true {
            currView.blur.blurRadius = CGFloat(value)
        }
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

    func handleCustomViewTap(_ gestureRecognizer: UITapGestureRecognizer){
        
        if(gestureRecognizer.view is CustomView) {
            controlStack.isHidden = false
            currView = gestureRecognizer.view as! CustomView
            for i in customViewList {
                if i.customViewID != currView.customViewID {
                    i.selected(isSelected: false)
                    i.editMode = false
                }
            }
            currView.selected(isSelected: true)
            currView.editMode = true
            //editMode = true
            intSlider.setValue(Float(currView.blur.blurRadius), animated: true)
        }
    }
    
    func handlePinchZoom(_ gestureRecognizer: UIPinchGestureRecognizer){
        print("pinched \(gestureRecognizer.scale)")
        
        if((gestureRecognizer.view as! CustomView) == currView) {
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
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
        
        if(!isHideMode) {
            createCustomView(xTouchPoint: touchPoint.x, yTouchPoint: touchPoint.y, width: 200, height: 200)
        
            for i in customViewList {
                if i.customViewID != currView.customViewID {
                    i.selected(isSelected: false)
                    i.editMode = false
                }
            }
        } else {
            hideImageButton.isHidden = true
            isHideMode = false
        }
    }
    
    func createCustomView(xTouchPoint: CGFloat, yTouchPoint: CGFloat, width: CGFloat, height: CGFloat){
    
        let c = CustomView(frame: CGRect(x: xTouchPoint, y: yTouchPoint, width: width, height: width))
        c.customViewID = iterVal
        c.selected(isSelected: true)
        c.editMode = true
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
            delete.alpha = 0.4
            delete.isEnabled = false
            intSlider.isEnabled = false
        case true:
            intText.textColor = UIColor(hexString: "EEEEEE")
            intText.alpha = 1
            intSlider.tintColor = UIColor(hexString: "EEEEEE")
            intSlider.thumbTintColor = UIColor(hexString: "EEEEEE")
            delete.alpha = 1
            delete.isEnabled =  true
            intSlider.alpha = 1
            intSlider.isEnabled = true
        default:
            break
        }
    }
}
