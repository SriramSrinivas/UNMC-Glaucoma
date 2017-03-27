import UIKit

class SideView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#424242")

        addSubview(addToggleGrid())
    }

    func addToggleGrid() -> UISwitch{
        let t = UISwitch()
        t.frame = CGRect(x: self.frame.size.width/4, y: self.frame.height/2, width: 100, height: 100)
        t.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        return t
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        print("Curr Switch : \(value)")
        switch (value) {
            case true:
                ViewController().showGridLines()
            case false:
                ViewController().hideGridLines()
        }
    }
}