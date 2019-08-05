//
//  Globals.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/23/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

//TODO for the project
//refactorization - bring globals here for a starter, and make code easier to follow
// error checking, not implemeneted in the filedownlaods
// completion handler for files
// switch mantiance
// hidden objects still have to be dealt with
// smaller view for the picker view would be nice
// custom objects not being hardcoded into place.


import Foundation



@objc class Globals : NSObject {
//    if (word == "blurPoints")
//    {
//    return 1
//    }
//    if (word == "greyPoints"){
//    return 2
//    }
//    if (word == "colorPoints"){
//    return 3
//    }
//    if (word == "hiddenPoints"){
//    return 4
//    }
//    if (word == "screenshot"){
//    return 5
    
    var backGrounds = ["mainTes", "tes-1", "tes"]
    var fileTypes = ["blurPoints","greyPoints", "colorPoints", "hiddenPoints","screenshot" ]
    var currentBackGround = "mainTes"
    var currentFolderExport = ""
    let distances = [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
    var distancesInCGFLOAT = CGFloat()
    var cameraImage : UIImage?
    var isLoggedIntoBox : Bool = false
    
    static let shared = Globals()
    
    @objc class func sharedInstance() -> Globals {
        return Globals.shared
    }
    override init() {
        currentBackGround = "mainTes"
    }
    
    func getCurrentBackGround() -> String{
        return currentBackGround
    }
    func setCurrentBackGround(newBack: String){
        currentBackGround = newBack
    }
    func getdistances() -> [Double] {
        return distances
    }
    func getdistancesINCGFloat() -> [CGFloat] {
        return [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
    }
    func setcurrentFolderExport(newFolder: String) {
        currentFolderExport = newFolder
    }
    func getcurrentFolderExport() -> String {
        return currentFolderExport
    }
    func getCameraImage() -> UIImage {
        return cameraImage ?? UIImage(named: currentBackGround)!
    }
    func setCameraImage(image: UIImage) {
        cameraImage = image
    }
    func getDate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
}
