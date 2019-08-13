//
//  DataProcessing.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/22/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

//import Foundation

class LocalFileModel {
    var name : String?
    var blurdata: String?
    var colordata: String?
    var greydata: String?
    var savedata: String?
    var image: NSData?
    var ishiddendata : String?
    
    
    init(name: String, blurdata: String, colordata: String, greydata: String, ishiddendata: String,savedata: String, image: NSData) {
        self.name = name
        self.blurdata = blurdata
        self.colordata = colordata
        self.greydata = greydata
        self.savedata = savedata
       // let nImage : Data = Data(image)
        self.image = image
        self.ishiddendata = ishiddendata
    }
}
