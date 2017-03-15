import UIKit

class SideView: UIView {

    let views = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#424242")
        addSubview(addToggleGrid())
    }

    func addToggleGrid() -> UISwitch{
        let t = UISwitch()
        t.frame = CGRect(x: self.frame.size.width/4, y: self.frame.height/2, width: 100, height: 100)
        return t
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}