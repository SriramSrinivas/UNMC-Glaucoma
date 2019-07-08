//
//  UIGenerics.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/8/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

enum colors {
    case red
    case darkGray
}
extension colors {
    init?(color: String) {
        if color == "red" {
            self = .red
        } else if color == "darkGray" {
            self = .darkGray
        } else {
            self = .darkGray
        }
    }
}
func setUpButton<T:UIButton>(_ a: inout T, title: String){
    a.backgroundColor = .gray
    a.setTitleColor(.black, for: .init())
    a.setTitle(title, for: .init())
    a.translatesAutoresizingMaskIntoConstraints = false
}
func setUpButton<T:UIButton>(_ a: inout T, title: String, cornerRadius: Int, borderWidth: Int, color: String){
    
    switch colors(color: color) {
    case .red?:
        a.layer.borderColor = UIColor.red.cgColor
    default:
        a.layer.borderColor = UIColor.darkGray.cgColor
    }
    a.backgroundColor = .gray
    a.setTitleColor(.black, for: .init())
    a.setTitle(title, for: .init())
    a.layer.cornerRadius = CGFloat(cornerRadius)
    a.layer.borderWidth = CGFloat(borderWidth)
    a.translatesAutoresizingMaskIntoConstraints = false
}
func editableTextView<T:UITextView>(_ a: inout T, text: String, borderWidth: Double, cornerRaduis: Double, fontSize : Int){
    a.layer.borderWidth = CGFloat(borderWidth);
    a.layer.cornerRadius = CGFloat(cornerRaduis);
    a.layer.borderColor = UIColor.gray.cgColor
    a.text = text
    a.clearsOnInsertion = true
    a.textColor = UIColor.lightGray
    a.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
    a.textAlignment = .center
    a.isEditable = true
    a.isScrollEnabled = false
    a.translatesAutoresizingMaskIntoConstraints = false
    a.keyboardType = .decimalPad
    a.resignFirstResponder()
}

func nonEditableTextView<T:UITextView>(_ textView: inout T, text: String, fontSize: Int){
    textView.text = text
    textView.font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
    textView.textAlignment = .center
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.isSelectable = false
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.textAlignment = .center
}

func imageViewSetUp<T:UIImageView>(_ imageView: inout T, image: UIImage){
    imageView.image? = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = false
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .clear
}

