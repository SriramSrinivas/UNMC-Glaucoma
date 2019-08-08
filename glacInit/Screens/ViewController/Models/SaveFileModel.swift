//
//  SaveFileModel.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/6/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation





struct SaveModel {
    let effect : effectType
    let height : Double
    let width : Double
    let midx : Double
    let midy : Double
    let viewValue : Int
    var anchored : effectAnchored = .NotAnchored
    init(line: String) {
        var nLine = line.components(separatedBy: ",")
        if (nLine.count == 7){
            effect = effectType(effect: nLine[0])!
            height = Double(nLine[1])!
            width = Double(nLine[2])!
            midx = Double(nLine[3])!
            midy = Double(nLine[4])!
            viewValue = Int(nLine[5])!
            if !nLine[6].isEmpty {
                anchored = effectAnchored(flag: nLine[6])
            } else {
                anchored = .NotAnchored
            }
        } else {
            effect = effectType.blur
            height = 0
            width = 0
            midx = 0
            midy = 0
            viewValue = 0
            anchored = .NotAnchored
        }
    }
}
