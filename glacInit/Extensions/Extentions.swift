/*************************************************************************
 *
 * UNIVERSITY OF NEBRASKA AT OMAHA CONFIDENTIAL
 * __________________
 *
 *  [2018] - [2019] University of Nebraska at Omaha
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of University of Nebraska at Omaha and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to University of Nebraska at Omaha
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from University of Nebraska at Omaha.
 *
 * Code written by Lyle Reinholz and Parshav Chauhan.
 */

import Foundation
import UIKit
import SwiftMessages
import CoreGraphics

enum stackType{
    case sideStack, controlStack
}
extension UIImage{
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        
        let drawRect = CGRect(x: 0,y: 0,width: size.width,height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
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
        let view = MessageView.viewFromNib(layout: .cardView)
        
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
    
    func reachibiltyChanged(online:Bool){
        let view = MessageView.viewFromNib(layout: .statusLine)
        
        view.configureTheme(.success)
        view.configureDropShadow()
        view.tapHandler = { _ in SwiftMessages.hide() }
        
        if online {
            view.configureTheme(.success)
            view.configureContent(body: "Internet connection back online")
        }
        else {
            view.configureTheme(.error)
            view.configureContent(body: "Internet connection appears to be offline")
        }
    
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        
        SwiftMessages.show(config:config,view:view)
    }
    
}

extension UIAlertController {
    @objc func textDidChangeInLoginAlert() {
        if let action = actions.last {
            var attributedString : NSAttributedString;
            if Regex("[^~%&*{}\\:<>?/+|\"]+$").test(input: (textFields?[0].text)!) {
                attributedString = NSAttributedString(string: "")
                self.setValue(attributedString, forKey: "attributedMessage")
                action.isEnabled = true
            }
            else {
                attributedString = NSAttributedString(string: "Error: Don't use these characters \n ~ % & * { } \\ : < > ? / + | \" ", attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor : UIColor.init(hexString: "#e74c3c")
                    ])
                self.setValue(attributedString, forKey: "attributedMessage")
                action.isEnabled = false
            }
        }
    }
}

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = UIColor(hexString: "#000000")
            self.addSubview(indicator)
            indicator.startAnimating()
            self.isEnabled = false
            self.backgroundColor = UIColor(hexString: "#bdc3c7")
            self.alpha = 0.7
        } else {
            self.setTitle("Export", for: UIControl.State.normal)
            self.backgroundColor = UIColor(hexString: "#0D47A1")
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
