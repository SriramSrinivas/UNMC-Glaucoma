import UIKit
import VisualEffectView

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    let blur = VisualEffectView()
    let blurButton = UIButton()
    var isBlur: Bool = false

    let sideStack = UIStackView()
    let controlStack = UIStackView()
    let toggleStack = UIStackView()
    let sliderStack = UIStackView()

    var gridViews = [UIView]()
    
    var tBlurInt = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        mainImgView.addGestureRecognizer(tap)

        let sideView = UIView(frame:  CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)

        initSideView(sideView: sideView)
        initSaveCancel(sideView: sideView)
        initToggleStack(sideView: sideView)
        
        addSlider(view: sideView)

        addGridLineUpdate(mainView: mainImgView)
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

        sideStack.axis = UILayoutConstraintAxis.vertical
        sideStack.distribution = UIStackViewDistribution.equalSpacing
        sideStack.alignment = UIStackViewAlignment.center
        sideStack.spacing = 20.0
        sideStack.translatesAutoresizingMaskIntoConstraints = false

        sideStack.addArrangedSubview(bButton)
        sideStack.addArrangedSubview(cloneButton)

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

    func initToggleStack(sideView: UIView){

        let gridSwitch = UISwitch()
        gridSwitch.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gridSwitch.widthAnchor.constraint(equalToConstant: 100).isActive = true
        gridSwitch.isOn = true
        gridSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)

        let origSwitch = UISwitch()
        origSwitch.heightAnchor.constraint(equalToConstant: 50).isActive = true
        origSwitch.widthAnchor.constraint(equalToConstant: 100).isActive = true

        toggleStack.axis = UILayoutConstraintAxis.vertical
        toggleStack.distribution = UIStackViewDistribution.equalSpacing
        toggleStack.alignment = UIStackViewAlignment.center
        toggleStack.spacing = 5.0
        toggleStack.translatesAutoresizingMaskIntoConstraints = false

        toggleStack.addArrangedSubview(gridSwitch)
        toggleStack.addArrangedSubview(origSwitch)

        sideView.addSubview(toggleStack)

        toggleStack.centerXAnchor.constraint(equalTo: sideView.centerXAnchor).isActive = true
        toggleStack.bottomAnchor.constraint(equalTo: sideView.bottomAnchor).isActive = true
    }

    func addBlur(xLoc: CGFloat, yLoc: CGFloat){

        blur.frame = CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 100, height: 100)
        blur.layer.borderWidth = 5
        blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
        blur.blurRadius = 10
        tBlurInt = blur.blurRadius

        blur.isHidden = false

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        blur.addGestureRecognizer(gestureRecognizer)

        self.view.addSubview(blur)
    }

    func loadImage(mainImgView: UIView){

        let image = UIImage(named: "tes-1");
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        imageView.image = image
        mainImgView.addSubview(imageView)

        let image2 = image!.crop(rect: CGRect(x: 500, y: 500, width: 800, height: 800))
        let image2view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image2view.backgroundColor = UIColor(patternImage: image2)
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        image2view.addGestureRecognizer(gestureRecognizer1)
        view.addSubview(image2view)


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
        line1.layer.borderColor = UIColor.green.cgColor

        let line2 = UIButton()
        line2.frame = CGRect(x: mainView.frame.width*0.66, y: 0, width: 10, height: mainView.frame.height)
        line2.layer.borderWidth = 10
        line2.layer.borderColor = UIColor.green.cgColor

        let line3 = UIButton()
        line3.frame = CGRect(x: 0, y: mainView.frame.height*0.3, width: mainView.frame.width, height: 10)
        line3.layer.borderWidth = 10
        line3.layer.borderColor = UIColor.gray.cgColor

        let line4 = UIButton()
        line4.frame = CGRect(x: 0, y: mainView.frame.height*0.66, width: mainView.frame.width, height: 10)
        line4.layer.borderWidth = 10
        line4.layer.borderColor = UIColor.gray.cgColor

        gridViews.append(line1)
        gridViews.append(line2)
        gridViews.append(line3)
        gridViews.append(line4)

        for i in gridViews {
            mainView.addSubview(i)
        }
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
        isBlur = false
    }

    func cancelTap(sender: UIButton!){
        blur.isHidden = true

        showStack(stack: .sideStack)
        isBlur = false
    }

    func cloneTap(sender: UIButton!){

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

    func switchChanged(mySwitch: UISwitch) {
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

    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
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

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let _ = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)

        //if(isBlur) {
            //addBlur(xLoc: touchPoint.x, yLoc: touchPoint.y)
        //}
    }
}

