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
 * Code written by Lyle Reinholz.
 */

import Foundation
import UIKit


func setUpButton<T:UIButton>(_ a: inout T, title: String){
    a.backgroundColor = .gray
    a.setTitleColor(.black, for: .init())
    a.setTitle(title, for: .init())
    a.translatesAutoresizingMaskIntoConstraints = false
}
func setUpButton<T:UIButton>(_ a: inout T, title: String, cornerRadius: Int, borderWidth: Int, color: CGColor){
    a.layer.borderColor = color
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
    a.textColor = UIColor.white
    a.layer.backgroundColor = UIColor.lightGray.cgColor
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
    textView.textColor = UIColor.white
    textView.backgroundColor = .clear
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

