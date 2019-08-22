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

//TODO for the project
//refactorization - bring globals here for a starter, and make code easier to follow
// error checking, not implemeneted in the filedownlaods
// hidden objects still have to be dealt with
// smaller view for the picker view would be nice
// custom objects not being hardcoded into place.

// add automatic switching when logging in and out box to .box or .local
// slow transitions for new
// switch added new functionality so got to update flow chart 


import Foundation



@objc class Globals : NSObject {

    
    var backGrounds : [BackgroundImage] 
    var fileTypes = ["blurPoints","greyPoints", "colorPoints", "hiddenPoints","screenshot" ]
    var currentBackGround : BackgroundImage
    var currentFolderExport = ""
    let distances = [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
    var distancesInCGFLOAT = CGFloat()
    var cameraImage : UIImage?
    var isLoggedIntoBox : Bool = false
    var importAndExportLoaction = dataSource.box
    
    static let shared = Globals()
    
    @objc class func sharedInstance() -> Globals {
        return Globals.shared
    }
    override init() {
        backGrounds = {
            let temp = BackgroundImage()
            temp.Backgroundimage = UIImage(named: "mainTes")
            temp.ID = 0
            temp.title = "mainTes"
            temp.isImported = .original
//            let temp1 = BackgroundImage()
//            temp1.Backgroundimage = UIImage(named: "tes-1")
//            temp1.ID = 0
//            temp1.title = "tes-1"
//            temp1.isImported = .original
//            let temp2 = BackgroundImage()
//            temp2.Backgroundimage = UIImage(named: "tes")
//            temp2.ID = 0
//            temp2.title = "tes"
//            temp2.isImported = .original
            let temp3 = BackgroundImage()
            temp3.Backgroundimage = UIImage(named:"plus")
            temp3.ID = 0
            temp3.title = "plus"
            temp3.isImported = .original
            return [temp, temp3]
            //     return [temp]
        }()
        let imagesToBeAdded = PersistanceService.fetch(SaveImageData.self)
        //var count = 5
        for image in imagesToBeAdded {
            let temp = BackgroundImage()
            temp.Backgroundimage = UIImage(data: image.image!)
            temp.ID = Int(image.id)
            temp.title = image.name
            temp.isImported = .imported
           // count = count + 1
            if !(temp.Backgroundimage == nil) {
                backGrounds.insert(temp, at: backGrounds.count - 1)
            }
        }
        currentBackGround = backGrounds[0]
    }
    
    func getCurrentBackGround() -> BackgroundImage{
        return currentBackGround
    }
    func setCurrentBackGround(newBack: BackgroundImage){
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
        return cameraImage ?? currentBackGround.Backgroundimage!
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
