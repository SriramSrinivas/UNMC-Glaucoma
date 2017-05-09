
import UIKit
import VisualEffectView

class CustomView: UIView {
    
    let blur = VisualEffectView()
    
    override init(frame: CGRect) {
        blur.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        super.init(frame: frame)
        
        addSubview(blur)
        
        //layer.cornerRadius = frame.size.width/2
        
        blur.layer.cornerRadius = frame.size.width/2
        blur.layer.borderWidth = 5
        blur.blurRadius = 10
        blur.layer.borderColor = UIColor(hexString: "F44556").cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
