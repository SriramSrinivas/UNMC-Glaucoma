import UIKit
import VisualEffectView

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
    let blur = VisualEffectView()
    let blurButton = UIButton()
    let blackButton = UIButton()
    let undoButton = UIButton()
    let gridRect1 = UIButton()
    let gridRect2 = UIButton()
    var isBlur: Bool = false
    var isBlack: Bool = false
    var tag = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainImgView = UIView(frame: CGRect(x: 0, y: 0, width: (screenSize.width - screenSize.width/5), height: screenSize.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        mainImgView.addGestureRecognizer(tap)

        let sideView = UIView(frame:  CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)
        //addGridLines(view: mainImgView)

        addToggle(sideView: sideView)
        addSlider(sideView: sideView)

        initSideView(sideView: sideView)
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
        //blkButton.addTarget(self, action: #selector(blackTap), for: .touchUpInside)

        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(bButton)
        stackView.addArrangedSubview(cloneButton)

        sideView.addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: sideView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: sideView.centerYAnchor).isActive = true
    }

    func addBlur(xLoc: CGFloat, yLoc: CGFloat){

        blur.frame = CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 300, height: 300)
        blur.layer.borderWidth = 10
        blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
        blur.blurRadius = 10

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

    func addSlider(sideView: UIView){

        let slider = UISlider()

        slider.frame = CGRect(x: sideView.frame.size.width/3, y: screenSize.height - 100, width: 100, height: 100)
        slider.addTarget(self, action: #selector(sliderChanged), for: UIControlEvents.valueChanged)

        sideView.addSubview(slider)
    }

    func addGridLines(view: UIView) {

        gridRect1.frame = CGRect(x: view.frame.size.width/3 , y: -10, width: view.frame.size.width/3 , height: (view.frame.size.height) + 20)
        gridRect1.layer.borderWidth = 4
        gridRect1.layer.borderColor = UIColor.white.cgColor

        gridRect2.frame = CGRect(x: -10, y: view.frame.size.height/3, width: (view.frame.size.width) + 20, height: view.frame.height/3)
        gridRect2.layer.borderWidth = 4
        gridRect2.layer.borderColor = UIColor(hexString: "F44556").cgColor
    }

    func blurTap(sender: UIButton!) {
        isBlur = true
        print("BLur Tapped")
    }

    func undoTap(sender: UIButton!){
        let viewWithTag = self.view.viewWithTag(tag - 1)
        viewWithTag?.removeFromSuperview()
        if(tag != 1) {
            tag -= 1
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

        print("Handle Pan")

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
        else if(isBlack) {
            print("No")
        }
    }
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

