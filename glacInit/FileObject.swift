//
//  FileObject.swift
//  glacInit
//
//  Created by Abdullahi Mahamed on 10/26/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit


enum FileType : String {
    case PNG = "png"
    case CSV = "csv"
}

struct FileObject {
    var name: String
    var path : URL
    var type: FileType
    
    init(name:String,type:FileType){
        self.name = "\(name).\(type.rawValue)"
        self.type = type
        self.path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name)")!
    }
    
    func saveCSV(grid:Matrix){
        let distances: [CGFloat] = [-1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
        var csvText = ",-1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1"
        for (row,i) in distances.enumerated() {
            var newLine = ""
            for (column,_) in distances.enumerated() {
                if(column == 0){
                    newLine = "\(i),\(grid[row,column])"
                }
                else {
                    newLine = "\(newLine),\(grid[row,column])"
                }
            }
            csvText = "\(csvText)\n\(newLine)"
        }
        
        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed create to file")
            print("\(error)")
        }
    }
    
    func savePNG(view:UIView){
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        //mainImgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        if let data = UIImagePNGRepresentation(image!){
            do {
                try data.write(to: path)
            } catch {
                
            }
        }
    }
    
}
