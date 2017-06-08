import UIKit
import VisualEffectView

class CustomView: UIView {
    
    let blur = VisualEffectView()
    var customViewID = 0
    var editMode = true
    
    override init(frame: CGRect) {
        blur.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        blur.autoresizesSubviews = true
        
        super.init(frame: frame)
        
        blur.blurRadius = 0
        addSubview(blur)
    }
    
    func selected(isSelected: Bool){
        switch isSelected {
        case true:
            blur.layer.borderWidth = 5
            blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
        case false:
            blur.layer.borderWidth = 0
        default: break
        }
    }
    
    func setBlurColor(color: String){
        blur.layer.borderColor = UIColor(hexString: color).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
