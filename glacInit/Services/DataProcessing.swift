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
//import Foundation


enum LocalFileLoadingError: Error {
    case errorInNameLoading
    case errorInDataLoading
    case errorInImageLoading
}

class LocalFileModel {
    var name : String?
    var blurdata: String?
    var colordata: String?
    var greydata: String?
    var savedata: String?
    var image: NSData?
    var ishiddendata : String?
    
    
    init(name: String?, blurdata: String?, colordata: String?, greydata: String?, ishiddendata: String?,savedata: String?, image: NSData?) {
        self.name = name ?? "error"
        self.blurdata = blurdata ?? "error"
        self.colordata = colordata ?? "error"
        self.greydata = greydata ?? "error"
        self.savedata = savedata ?? "error"
       // let nImage : Data = Data(image)
        self.image = image ?? NSData.init()
        self.ishiddendata = ishiddendata ?? "error"
        
    }
    
    func CheckData() throws {
        if name == "error" {
            throw LocalFileLoadingError.errorInNameLoading
        }
        if blurdata == "error" {
            throw LocalFileLoadingError.errorInDataLoading
        }
        if colordata == "error" {
            throw LocalFileLoadingError.errorInDataLoading
        }
        if greydata == "error" {
            throw LocalFileLoadingError.errorInDataLoading
        }
        if ishiddendata == "error" {
            throw LocalFileLoadingError.errorInDataLoading
        }
        if savedata ==  "error" {
            throw LocalFileLoadingError.errorInDataLoading
        }
        if image == NSData.init() {
            throw LocalFileLoadingError.errorInImageLoading
        }
    }
   
}
