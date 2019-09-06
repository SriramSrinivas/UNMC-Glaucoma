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

struct SaveModel {
    var effect : [effectType]
    let height : Double
    let width : Double
    let midx : Double
    let midy : Double
    let viewValue : Int
    let greyValue : Int
    let colorValue : Int
    var anchored : effectAnchored = .NotAnchored
    init(line: String) {
        var nLine = line.components(separatedBy: "]")
        if (nLine.count == 2){
            //var nLine = line.components(separatedBy: "]")
            var effectArray = nLine[0].components(separatedBy: ",")
            var numbers = nLine[1].components(separatedBy: ",")
            //var count = 0
            effect = []
            for line in effectArray {
                effect.append(effectType.init(effect: line)!)
            }
            
            //effect = [effectType(effect: nLine[0])!]
            height = Double(numbers[1])!
            width = Double(numbers[2])!
            midx = Double(numbers[3])!
            midy = Double(numbers[4])!
            viewValue = Int(numbers[5])!
            var num = numbers[6].components(separatedBy: ".")
            greyValue = Int(num[0])!
            num = numbers[7].components(separatedBy: ".")
            colorValue = Int(num[0])!
            if !numbers[8].isEmpty {
                anchored = effectAnchored(flag: numbers[8])
            } else {
                anchored = .NotAnchored
            }
        } else {
            effect = [effectType.blur]
            height = 0
            width = 0
            midx = 0
            midy = 0
            viewValue = 0
            greyValue = 0
            colorValue = 0
            anchored = .NotAnchored
        }
    }
}
