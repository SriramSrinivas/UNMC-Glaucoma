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
 * Code written by Lyle Reinholz and Abdullahi Mahamed.
 */


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
    var Matrix: String?
    
    init(name:String,type:FileType){
        self.name = "\(name).\(type.rawValue)"
        self.type = type
        self.path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name)")!
    }
    
    mutating func saveCSV(grid:Matrix){
        
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
        Matrix = csvText
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
        if let data = image!.pngData(){
            do {
                try data.write(to: path)
            } catch {
                
            }
        }
    }
    
}
