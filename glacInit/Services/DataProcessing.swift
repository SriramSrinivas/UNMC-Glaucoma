//
//  DataProcessing.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/22/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

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
