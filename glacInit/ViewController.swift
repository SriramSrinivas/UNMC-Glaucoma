import UIKit
import VisualEffectView
import SwiftHSVColorPicker

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    let blur = VisualEffectView()
    let blurButton = UIButton()
    var isBlur: Bool = false
    var isHideMode: Bool = false
    let tempFrame = UIView()
    let tempFrameColor = UIView()
    var bckImage = UIImage()
    let colorPicker = SwiftHSVColorPicker()
    
    let doggoImage = UIView()
    let trashImage = UIView()

    let sideStack = UIStackView()
    let controlStack = UIStackView()
    let toggleStack = UIStackView()
    let sliderStack = UIStackView()
    let cloneStack = UIStackView()

    var gridViews = [UIView]()
    var tBlurInt = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        mainImgView.addGestureRecognizer(tap)

        let sideView = UIView(frame:  CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))
        sideView.layer.zPosition = 1

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)

        initSideView(sideView: sideView)
        initSaveCancel(sideView: sideView)
        initToggle(sideView: sideView)
        
        addSlider(view: sideView)
        addCloneSideStack(sideView: sideView)

        addGridLineUpdate(mainView: mainImgView)
        
        addColorPicker(sideView: sideView)
        
        addDoggo()
        addTrash()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSideView(sideView: UIView){

        let bButton = UIButton()
        bButton.setTitle("Blur", for: UIControlState.normal)
        bButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        bButton.backgroundColor = UIColor(hexString: "#00BCD4")
        bButton.addTarget(self, action: #selector(blurTap), for: .touchUpInside)

        let cloneButton = UIButton()
        cloneButton.setTitle("Clone", for: UIControlState.normal)
        cloneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cloneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cloneButton.backgroundColor = UIColor(hexString: "#0D47A1")
        cloneButton.addTarget(self, action: #selector(cloneTap), for: .touchUpInside)
        
        let colorButton = UIButton()
        colorButton.setTitle("Color Tint", for: UIControlState.normal)
        colorButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        colorButton.backgroundColor = UIColor(hexString: "#E91E63")
        colorButton.addTarget(self, action: #selector(colorTap), for: .touchUpInside)
        
        let hideButton = UIButton()
        hideButton.setTitle("Hide Object", for: .normal)
        hideButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hideButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hideButton.backgroundColor = UIColor(hexString: "651FFF")
        hideButton.addTarget(self, action: #selector(hideTap), for: .touchUpInside)

        sideStack.axis = UILayoutConstraintAxis.vertical
        sideStack.distribution = UIStackViewDistribution.equalSpacing
        sideStack.alignment = UIStackViewAlignment.center
        sideStack.spacing = 20.0
        sideStack.translatesAutoresizingMaskIntoConstraints = false

        sideStack.addArrangedSubview(bButton)
        sideStack.addArrangedSubview(cloneButton)
        //sideStack.addArrangedSubview(colorButton)
        sideStack.addArrangedSubview(hideButton)

        sideView.addSubview(sideStack)

        sideStack.centerXAnchor.constraint(equalTo: sideView.centerXAnchor).isActive = true
        sideStack.centerYAnchor.constraint(equalTo: sideView.centerYAnchor).isActive = true
    }

    func initSaveCancel(sideView: UIView){

        let save = UIButton()
        save.setTitle("Save", for: UIControlState.normal)
        save.heightAnchor.constraint(equalToConstant: 50).isActive = true
        save.widthAnchor.constraint(equalToConstant: 100).isActive = true
        save.backgroundColor = UIColor(hexString: "#4CAF50")
        save.addTarget(self, action: #selector(saveTap), for: .touchUpInside)

        let cancel = UIButton()
        cancel.setTitle("Cancel", for: UIControlState.normal)
        cancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancel.backgroundColor = UIColor(hexString: "#f44336")
        cancel.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)

        controlStack.axis = UILayoutConstraintAxis.horizontal
        controlStack.distribution = UIStackViewDistribution.equalSpacing
        controlStack.alignment = UIStackViewAlignment.center
        controlStack.spacing = 10.0
        controlStack.translatesAutoresizingMaskIntoConstraints = false

        controlStack.addArrangedSubview(save)
        controlStack.addArrangedSubview(cancel)

        sideView.addSubview(controlStack)

        controlStack.centerXAnchor.constraint(equalTo: sideView.centerXAnchor).isActive = true
        controlStack.bottomAnchor.constraint(equalTo: sideView.bottomAnchor).isActive = true

        controlStack.isHidden = true
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
    
    func addCloneSideStack(sideView: UIView){
        
        let cloneButton = UIButton()
        cloneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cloneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cloneButton.addTarget(self, action: #selector(cloneToTap), for: .touchUpInside)
        cloneButton.setTitle("Clone To", for: UIControlState.normal)
        cloneButton.backgroundColor = UIColor.red
        
        let sizeSlider = UISlider()
        sizeSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sizeSlider.widthAnchor.constraint(equalToConstant: (sideView.frame.width - 50)).isActive = true
        sizeSlider.minimumValue = 1
        sizeSlider.maximumValue = 4
        
        cloneStack.axis = UILayoutConstraintAxis.vertical
        cloneStack.distribution = UIStackViewDistribution.equalSpacing
        cloneStack.alignment = UIStackViewAlignment.center
        cloneStack.spacing = 5.0
        cloneStack.translatesAutoresizingMaskIntoConstraints = false
        
        cloneStack.addArrangedSubview(cloneButton)
        cloneStack.addArrangedSubview(sizeSlider)
        
        sideView.addSubview(cloneStack)
        
        cloneStack.centerXAnchor.constraint(equalTo: sideView.centerXAnchor).isActive = true
        cloneStack.bottomAnchor.constraint(equalTo: sideView.centerYAnchor).isActive = true
        
        cloneStack.isHidden = true
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

        let intSlider = UISlider()
        intSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        intSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        intSlider.addTarget(self, action: #selector(sliderIntensity), for: UIControlEvents.valueChanged)
        intSlider.minimumValue = 1
        intSlider.maximumValue = 10

        sliderStack.axis = UILayoutConstraintAxis.vertical
        sliderStack.distribution = UIStackViewDistribution.equalSpacing
        sliderStack.alignment = UIStackViewAlignment.center
        sliderStack.spacing = 10.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

        sliderStack.addArrangedSubview(sizeText)
        sliderStack.addArrangedSubview(sizeSlider)
        sliderStack.addArrangedSubview(intText)
        sliderStack.addArrangedSubview(intSlider)

        view.addSubview(sliderStack)

        sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderStack.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        sliderStack.isHidden = true
    }

    func addGridLineUpdate(mainView: UIView){

        let line1 = UIButton()
        line1.frame = CGRect(x: mainView.frame.width*0.3, y: 0, width: 10, height: mainView.frame.height)
        line1.layer.borderWidth = 10
        line1.layer.borderColor = UIColor.red.cgColor

        let line2 = UIButton()
        line2.frame = CGRect(x: mainView.frame.width*0.66, y: 0, width: 10, height: mainView.frame.height)
        line2.layer.borderWidth = 10
        line2.layer.borderColor = UIColor.red.cgColor

        let line3 = UIButton()
        line3.frame = CGRect(x: 0, y: mainView.frame.height*0.5, width: mainView.frame.width, height: 10)
        line3.layer.borderWidth = 10
        line3.layer.borderColor = UIColor.red.cgColor

        gridViews.append(line1)
        gridViews.append(line2)
        gridViews.append(line3)

        for i in gridViews {
            mainView.addSubview(i)
        }
    }
    
    func addColorPicker(sideView: UIView){
        
        colorPicker.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        sideView.addSubview(colorPicker)
        colorPicker.setViewColor(UIColor.red)
        colorPicker.isHidden = true
        
        tempFrameColor.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        tempFrameColor.layer.borderWidth = 5
        tempFrameColor.layer.borderColor = UIColor(hexString: "F44556").cgColor
        
        self.view.addSubview(tempFrameColor)
        
        tempFrameColor.isHidden = true
    }

    func blurTap(sender: UIButton!){
        isBlur = true
        showStack(stack: .controlStack)
        sliderStack.isHidden = false
        addBlur(xLoc: 300, yLoc: 300)
    }

    func saveTap(sender: UIButton!){
        let tempView = VisualEffectView()
        tempView.frame = blur.frame
        tempView.blurRadius = tBlurInt
        blur.isHidden = true
        self.view.addSubview(tempView)

        showStack(stack: .sideStack)
        cloneStack.isHidden = true
        isBlur = false
        isHideMode = false
    }

    func cancelTap(sender: UIButton!){
        blur.isHidden = true

        showStack(stack: .sideStack)
        cloneStack.isHidden = true
        isBlur = false
        isHideMode = false
        
        doggoImage.isHidden = false
        trashImage.isHidden = false
    }

    func cloneTap(sender: UIButton!){
        
        sideStack.isHidden = true
        cloneStack.isHidden = false
        controlStack.isHidden = false
        
        tempFrame.isHidden = false

        tempFrame.frame = CGRect(x: 400, y: 400, width: 100, height: 100)
        tempFrame.layer.borderWidth = 5
        tempFrame.layer.borderColor = UIColor(hexString: "F44556").cgColor

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        tempFrame.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(tempFrame)
    }
    
    func colorTap(sender: UIButton!){
        
        sideStack.isHidden = true
        colorPicker.isHidden = false
        
        tempFrameColor.isHidden = false
        
        tempFrameColor.backgroundColor = colorPicker.color
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        tempFrameColor.addGestureRecognizer(gestureRecognizer)

    }
    
    func hideTap(sender: UIButton!){
        
        print("Position : \(trashImage.frame.origin.x) and \(trashImage.frame.origin.y)")
        
        sideStack.isHidden = true
        controlStack.isHidden = false
        isHideMode = true
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
    }
    
    func addTrash(){
        
        var image = UIImage(named: "trashcan")
        
        image! = resizeImage(image: image!, targetSize: CGSize(width: 130, height: 130))
        
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        imageView.image = image
        
        trashImage.frame = CGRect(x: -21, y: 366, width: imageView.frame.size.width, height: imageView.frame.size.height)
        trashImage.backgroundColor = UIColor(patternImage: image!)
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(trashTap))
        trashImage.addGestureRecognizer(gestureRecognizer1)
        
        view.addSubview(trashImage)
    }
    
    func cloneToTap(sender: UIButton!){
        
        addClone(xLoc: tempFrame.frame.origin.x, yLoc: tempFrame.frame.origin.y)
    }

    func showStack(stack: stackType){
        switch(stack){
            case .sideStack:
                sideStack.isHidden = false
                controlStack.isHidden = true
                sliderStack.isHidden = true
            case .controlStack:
                sideStack.isHidden = true
                controlStack.isHidden = false
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
        let _ = mySwitch.isOn
        
        let color = colorPicker.color
        print("Color : \(color.debugDescription)")
    }

    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
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
        
        blur.blurRadius = CGFloat(value)
        tBlurInt = blur.blurRadius
    }
    
    func addClone(xLoc: CGFloat, yLoc: CGFloat){
        
        let image2 = bckImage.crop(rect: CGRect(x: (xLoc), y: (yLoc), width: 700, height: 700))
        let image2view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image2view.backgroundColor = UIColor(patternImage: image2)
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        image2view.addGestureRecognizer(gestureRecognizer1)
        
        view.addSubview(image2view)
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let _ = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)

        //if(isBlur) {
            //addBlur(xLoc: touchPoint.x, yLoc: touchPoint.y)
        //}
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
}

