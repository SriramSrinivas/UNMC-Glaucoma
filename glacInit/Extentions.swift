//
//  Extentions.swift
//  glacInit
//
//  Created by Parshav Chauhan on 4/25/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

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

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: 5, orientation: self.imageOrientation)
        return image
    }
}

extension UIView {
    func includesEffect(){

        print("Origin : \(self.frame.origin.x) and \(self.frame.origin.y)")

    }
}

extension UIViewController {
    
    func showToast(message: String, theme: Theme) {
        let view = MessageView.viewFromNib(layout: .CardView)
        
        view.configureTheme(theme)
        view.configureDropShadow()
        view.button?.setTitle("OK", for: .normal)
        
        view.buttonTapHandler = { _ in SwiftMessages.hide() }
        view.tapHandler = { _ in SwiftMessages.hide() }
        
        var title = ""
        
        switch theme {
        case .success:
            title = "Success"
        case .error:
            title = "Error"
        case .warning:
            title = "Warning"
        default:
            title = "Warning"
        }
        
        
        view.configureContent(title: title, body: message)
        
        SwiftMessages.show(view:view)
    
    }
}

extension UIAlertController {
    func textDidChangeInLoginAlert() {
        if let inputTextField = textFields?[0].text,let action = actions.last {
            action.isEnabled = Regex("^[\\w\\-. ]+$").test(input: inputTextField)
        }
    }
}
