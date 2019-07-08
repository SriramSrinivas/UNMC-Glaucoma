//
//  importFile.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/8/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

// Need SubjectName, background, and date
//questions:
// ahould data be changable and if so does the resaved data

import Foundation
import BoxContentSDK

// init will get the data needed from the user

class importFile {

    var subjectId: String
    var backGroundId: String
    var date: Date
     var type: FileType
    var path: URL
    
    init(subjectId: String, backGroundId: String, date: Date, file: FileType) {
        self.subjectId = subjectId
        self.backGroundId = backGroundId
        self.date = date
        self.type = file
        self.path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(subjectId)")!
    }
    
// sets the background
    
    func setBackGround() -> String{
        return backGroundId
    }
// method to get the files from box
    func downlaodFile(){
        let stream = OutputStream()
        //let file = FileManager.file
        let contentClient = BOXContentClient.default()
        //let localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.jpg"];
        let boxRequest = contentClient?.fileDownloadRequest(withID: "woah", to: stream)
//            [contentClient fileDownloadRequestWithID:@"file-id" toLocalFilePath:localFilePath];
        boxRequest?.perform(progress: { (_ totalBytesTransferred:Int64, _ totalBytesExpectedToTransfer:Int64) in
        }, completion: {(_ error: Error?) -> Void in
            if error == nil {
            }
             else {
        }
        })
    }
    

// method to go through the data and display the info

//struct FileObject {
//    var name: String
//    var path : URL
//    var type: FileType
//
//    init(name:String,type:FileType){
//        self.name = "\(name).\(type.rawValue)"
//        self.type = type
//        self.path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name)")!
//    }
//
//    func saveCSV(grid:Matrix){
//        let distances: [CGFloat] = [-1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
//        var csvText = ",-1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1"
//        for (row,i) in distances.enumerated() {
//            var newLine = ""
//            for (column,_) in distances.enumerated() {
//                if(column == 0){
//                    newLine = "\(i),\(grid[row,column])"
//                }
//                else {
//                    newLine = "\(newLine),\(grid[row,column])"
//                }
//            }
//            csvText = "\(csvText)\n\(newLine)"
//        }
//
//        do {
//            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
//        } catch {
//            print("Failed create to file")
//            print("\(error)")
//        }
//}

//

}
