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

//easy spot to through in information for the pictures. 

var customObjectList = [CustomObject]()

// height 768.0 (to display properly on the screen on any size of screen)
//width 1024.0

func createobjects(pictureID: Int, height: CGFloat, width: CGFloat) -> [CustomObject] {
    
    
            //819.2
    
   //let hello = ((735.0 / 819.2) * width)
//        let newHR = height / 768.0
//        let newWR = width /  819.2
//        var newt1 = 735.0 * newHR
//        var newt2 = 237.6 * newWR
//        print(newt1)
//        print(newt2)
    if (pictureID == 1) {
    customObjectList = [CustomObject(imageName: "doggo", xPos: ((413 / 819.2) * width), yPos: ((413 / 768) * height), sideSize: ((90 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "trashcan", xPos: ((-21 / 819.2) * width), yPos: ((366 / 768) * height), sideSize: ((130 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "cone", xPos: ((122 / 819.2) * width), yPos: ((361 / 768) * height), sideSize: ((60 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "cone", xPos: ((185 / 819.2) * width), yPos: ((325.5 / 768) * height), sideSize: ((60 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "ball", xPos: ((575.5 / 819.2) * width), yPos: ((385 / 768) * height), sideSize: ((50 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "kid1", xPos: ((380 / 819.2) * width), yPos: ((279.5 / 768) * height), sideSize: ((50 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "kid2", xPos: ((423.5 / 819.2) * width), yPos: ((271 / 768) * height), sideSize: ((50 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "peel", xPos: ((55.5 / 819.2) * width), yPos: ((460.5 / 768) * height), sideSize: ((56 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "helmet", xPos: ((176.5 / 819.2) * width), yPos: ((387 / 768) * height), sideSize: ((50 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "girl", xPos: ((735.0 / 819.2) * width), yPos: ((237.6 / 768) * height), sideSize: ((230 / 819.2) * width), alphaValue: 1),
                    CustomObject(imageName: "hydrant", xPos: ((606 / 819.2) * width), yPos: ((300 / 768) * height), sideSize: ((70 / 819.2) * width), alphaValue: 1)]
    return customObjectList
    }
    else {
    customObjectList = [CustomObject(imageName: "doggo", xPos: 413, yPos: 413, sideSize: 90, alphaValue: 1),
                    CustomObject(imageName: "trashcan", xPos: -21, yPos: 366, sideSize: 130, alphaValue: 1),
                    CustomObject(imageName: "cone", xPos: 122, yPos: 361, sideSize: 60, alphaValue: 1),
                    CustomObject(imageName: "cone", xPos: 185, yPos: 325.5, sideSize: 60, alphaValue: 1),
                    CustomObject(imageName: "ball", xPos: 575.5, yPos: 385, sideSize: 50, alphaValue: 1),
                    CustomObject(imageName: "kid1", xPos: 380, yPos: 279.5, sideSize: 50, alphaValue: 1),
                    CustomObject(imageName: "kid2", xPos: 423.5, yPos: 271, sideSize: 50, alphaValue: 1),
                    CustomObject(imageName: "peel", xPos: 55.5, yPos: 460.5, sideSize: 65, alphaValue: 1),
                    CustomObject(imageName: "helmet", xPos: 176.5, yPos: 387, sideSize: 50, alphaValue: 1),
                    CustomObject(imageName: "girl", xPos: 735.0, yPos: 237.6, sideSize: 230, alphaValue: 1),
                    CustomObject(imageName: "hydrant", xPos: 606, yPos: 300, sideSize: 70, alphaValue: 1)]
        return customObjectList
    }
}



