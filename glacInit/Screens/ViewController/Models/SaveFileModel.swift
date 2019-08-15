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
