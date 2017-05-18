import UIKit
import VisualEffectView

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    let blur = VisualEffectView()
    let blurButton = UIButton()
    var isBlur: Bool = false
    var isHideMode: Bool = false
    let tempFrame = UIView()
    let tempFrameColor = UIView()
    var bckImage = UIImage()
    
    let doggoImage = UIView()
    let trashImage = UIView()

    let controlStack = UIStackView()
    let toggleStack = UIStackView()
    let sliderStack = UIStackView()

    var gridViews = [UIView]()
    var tBlurInt = CGFloat()
    
    let intSlider = UISlider()
    var customViewList = [CustomView]()
    var currView = CustomView()
    var iterVal = 0
    
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
        
        addSlider(view: sideView)

        addGridLineUpdate(mainView: mainImgView)
        
        addDoggo()
        addTrash()
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

        let intText = UILabel()
        intText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        intText.text = "Blur Intensity"
        intText.textColor = UIColor.white

        let sizeText = UILabel()
        sizeText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sizeText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sizeText.text = "Blur Size"
        sizeText.textColor = UIColor.white

        let sizeSlider = UISlider()
        sizeSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sizeSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        sizeSlider.addTarget(self, action: #selector(sliderSize), for: UIControlEvents.valueChanged)
        sizeSlider.minimumValue = 1
        sizeSlider.maximumValue = 4
        
        let delete = UIButton()
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

        sliderStack.addArrangedSubview(sizeText)
        sliderStack.addArrangedSubview(sizeSlider)
        sliderStack.addArrangedSubview(intText)
        sliderStack.addArrangedSubview(intSlider)
        sliderStack.addArrangedSubview(delete)

        view.addSubview(sliderStack)

        sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //sliderStack.isHidden = true
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
        
        if (isHideMode) {
            doggoImage.isHidden = true
        }
    }
    
    func trashTap(sender: UITapGestureRecognizer!){
        print("Tap Trash")
        
        if (isHideMode) {
            trashImage.isHidden = true
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
        
        let c = CustomView(frame: CGRect(x: touchPoint.x - 100, y: touchPoint.y - 100, width: 200, height: 200))
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
        
        for i in customViewList {
            if i.customViewID != currView.customViewID {
                i.selected(isSelected: false)
                i.editMode = false
            }
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
    
    func freeDrawTest(){
    }
}
