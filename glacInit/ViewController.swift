import UIKit
import VisualEffectView

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    let blur = VisualEffectView()
    let blurButton = UIButton()
    var isBlur: Bool = false
    let sideStack = UIStackView()
    let controlStack = UIStackView()

    var views = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        mainImgView.addGestureRecognizer(tap)

        let sideView = UIView(frame:  CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)

        addToggle(sideView: sideView)

        initSideView(sideView: sideView)
        initSaveCancel(sideView: sideView)
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

    func addBlur(xLoc: CGFloat, yLoc: CGFloat){

        blur.frame = CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 100, height: 100)
        blur.layer.borderWidth = 5
        blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
        blur.blurRadius = 10

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
    }

    func addToggle(sideView: UIView){

        let screenHeight = screenSize.height
        let toggle = UISwitch()

        toggle.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight - 200, width: 100, height: 100)
        toggle.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)

        sideView.addSubview(toggle)
    }

    func addSlider(view: UIView){

        let text = UITextField()
        text.heightAnchor.constraint(equalToConstant: 100).isActive = true
        text.widthAnchor.constraint(equalToConstant: 100).isActive = true
        text.text = "Text"
        text.textColor = UIColor.green

        let text1 = UITextField()
        text1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        text1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        text1.text = "Text"
        text1.textColor = UIColor.green

        let radSlider = UISlider()
        radSlider.heightAnchor.constraint(equalToConstant: 100).isActive = true
        radSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        radSlider.addTarget(self, action: #selector(sliderChanged), for: UIControlEvents.valueChanged)

        let sizeSlider = UISlider()
        sizeSlider.heightAnchor.constraint(equalToConstant: 100).isActive = true
        sizeSlider.widthAnchor.constraint(equalToConstant: (view.frame.width - 50)).isActive = true
        //sizeSlider.addTarget(self, action: #selector(sliderChanged), for: UIControlEvents.valueChanged)

        let sliderStack = UIStackView()
        sliderStack.axis = UILayoutConstraintAxis.vertical
        sliderStack.distribution = UIStackViewDistribution.equalSpacing
        sliderStack.alignment = UIStackViewAlignment.center
        sliderStack.spacing = 10.0
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

        //sliderStack.addArrangedSubview(radSlider)
        sliderStack.addArrangedSubview(text1)
        sliderStack.addArrangedSubview(text)
        //sliderStack.addArrangedSubview(sizeSlider)

        view.addSubview(sliderStack)

        sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func addGridLineUpdate(mainView: UIView){

        let doYourPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        doYourPath.move(to: CGPoint(x: 300, y: 300))
        let layer = CAShapeLayer()
        layer.path = doYourPath.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.white.cgColor
        mainView.layer.addSublayer(layer)
    }

    func blurTap(sender: UIButton!){
        isBlur = true
        showStack(stack: .controlStack)
    }

    func saveTap(sender: UIButton!){
        let tempView = VisualEffectView()
        tempView.frame = blur.frame
        tempView.blurRadius = 2
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
            case .controlStack:
                sideStack.isHidden = true
                controlStack.isHidden = false
        }
    }

    func switchChanged(mySwitch: UISwitch) {
        var value = mySwitch.isOn

        print("Curr Switch : \(value)")
        switch (value) {
        case true:
            print("Hi")
        case false:
            print("Bye")
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

    func sliderChanged(slider: UISlider){
        var value = slider.value

        value = value*10
        blur.blurRadius = CGFloat(value)
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)

        if(isBlur) {
            addBlur(xLoc: touchPoint.x, yLoc: touchPoint.y)
        }
    }
}

enum stackType{
    case sideStack, controlStack
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

