import UIKit
import VisualEffectView

class ViewController: UIViewController {
        
    let screenSize: CGRect = UIScreen.main.bounds
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
        let sideView = SideView(frame:  CGRect(x: mainImgView.frame.size.width, y: 0, width: (screenSize.width - mainImgView.frame.size.width), height: screenSize.height))

        view.addSubview(mainImgView)
        view.addSubview(sideView)

        loadImage(mainImgView: mainImgView)
        addGridLines(view: mainImgView)
        showGridLines()

        addBlur(view: mainImgView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBlur(xLoc: CGFloat, yLoc: CGFloat){

        let d = UIView(frame: CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 100, height: 100))

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = d.frame
        blurEffectView.layer.cornerRadius = 50
        blurEffectView.clipsToBounds = true;

        blurEffectView.alpha = 0.9

        blurEffectView.tag = tag
        tag += 1

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //self.view.addSubview(blurEffectView)
    }

    func addBlur(view: UIView){
        let blur = VisualEffectView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        blur.blurRadius = 10
        view.addSubview(blur)
    }

    func addBlack(xLoc: CGFloat, yLoc: CGFloat){

        let d = UIView(frame: CGRect(x: (xLoc - 75), y: (yLoc - 75), width: 100, height: 100))
        d.backgroundColor = UIColor.black
        d.layer.cornerRadius = 50

        d.tag = tag
        tag += 1

        self.view.addSubview(d)
    }
    
    func loadImage(mainImgView: UIView){

        let image = UIImage(named: "tes-1");
        let imageView = UIImageView(frame: CGRect(x : 0, y: 0, width: mainImgView.frame.size.width, height: mainImgView.frame.size.height))
        imageView.image = image
        //imageView.contentMode = UIViewContentMode.scaleAspectFit
        mainImgView.addSubview(imageView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

    }

    func addBlurButton(sideView: UIView){

        let screenHeight = screenSize.height
        
        blurButton.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight/8, width: 100, height: 100)
        blurButton.backgroundColor = UIColor(hexString: "#1B5E20")
        blurButton.layer.cornerRadius = blurButton.frame.size.width/2
        blurButton.addTarget(self, action: #selector(blurTap), for: .touchUpInside)

        let label = UILabel(frame: CGRect(x: sideView.frame.size.width/2 - 25, y: screenHeight/8, width: 100, height: 100))
        label.text = "Blur"
        label.textColor = UIColor.white

        sideView.addSubview(blurButton)
        sideView.addSubview(label)
    }

    func addBlackButton(sideView: UIView){

        let screenHeight = screenSize.height

        blackButton.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight/3, width: 100, height: 100)
        blackButton.backgroundColor = UIColor(hexString: "#0D47A1")
        blackButton.layer.cornerRadius = blurButton.frame.size.width/2
        blackButton.addTarget(self, action: #selector(blackTap), for: .touchUpInside)

        let label = UILabel(frame: CGRect(x: sideView.frame.size.width/2 - 25, y: screenHeight/3, width: 100, height: 100))
        label.text = "Blind"
        label.textColor = UIColor.white

        sideView.addSubview(blackButton)
        sideView.addSubview(label)
    }

    func addUndoButton(sideView: UIView){

        let screenHeight = screenSize.height

        undoButton.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight/2, width: 100, height: 100)
        undoButton.backgroundColor = UIColor(hexString: "#b71c1c")
        undoButton.layer.cornerRadius = blurButton.frame.size.width/2
        undoButton.addTarget(self, action: #selector(undoTap), for: .touchUpInside)

        let label = UILabel(frame: CGRect(x: sideView.frame.size.width/2 - 25, y: screenHeight/2, width: 100, height: 100))
        label.text = "Undo"
        label.textColor = UIColor.white

        sideView.addSubview(undoButton)
        sideView.addSubview(label)
    }

    func addSlider(sideView: UIView){

        let screenHeight = screenSize.height
        let slider = UISwitch()

        slider.frame = CGRect(x: sideView.frame.size.width/4, y: screenHeight - 200, width: 100, height: 100)
        slider.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        //slider.addTarget(self, action: #selector(undoTap), for: .touchUpInside)

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

    func hideGridLines(){
        gridRect1.removeFromSuperview()
        gridRect2.removeFromSuperview()
    }

    func showGridLines(){
        view.addSubview(gridRect1)
        view.addSubview(gridRect2)
    }
    
    func blurTap(sender: UIButton!) {
        isBlur = true
        isBlack = false
        makeBorder(btn: blurButton)
        removeBorder(btn: blackButton)
    }

    func blackTap(sender: UIButton!){
        isBlur = false
        isBlack = true
        makeBorder(btn: blackButton)
        removeBorder(btn: blurButton)
    }

    func undoTap(sender: UIButton!){
        let viewWithTag = self.view.viewWithTag(tag - 1)
        viewWithTag?.removeFromSuperview()
        if(tag != 1) {
            tag -= 1
        }
    }

    func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn

        print("Curr Switch : \(value)")
        // Do something
    }

    func makeBorder(btn: UIButton){
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.white.cgColor
    }

    func removeBorder(btn: UIButton){
        btn.layer.borderWidth = 0
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let touchPoint = tapGestureRecognizer.location(in: tappedImage)

        if(isBlur) {
            addBlur(xLoc: touchPoint.x, yLoc: touchPoint.y)
        }
        else if(isBlack) {
            addBlack(xLoc: touchPoint.x, yLoc: touchPoint.y)
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

