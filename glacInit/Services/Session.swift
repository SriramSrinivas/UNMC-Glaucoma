//
//  Session.swift
//  glacInit
//
//  Created by Abdullahi Mahamed on 10/11/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit
import BoxContentSDK

class Session {
    var subjectId: String
    var exportCount = 0
    var distances =  [CGFloat]()
    var savedFiles = [FileObject]()
    //amount of times box tried to upload a file
    var uploadAttempt = 0
    var csvFilesUploadedCount = 0
    var pngFilesUploadedCount = 0
    
    init(currentSubjectId: String) {
        distances = [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
        subjectId = currentSubjectId
    }
    
    func saveGridData(mainView:UIView,customViewList:[CustomViewUpdate]){
        exportCount = exportCount + 1
        let width = mainView.frame.width
        let height = mainView.frame.height
        let halfWidth = width/2
        let halfHeight = height/2
        
        var blurGrid = Matrix(rows:17,columns:17)
        var greyGrid = Matrix(rows:17,columns:17)
        var hiddenGrid = Matrix(rows: 17, columns: 17)
        var colorGrid = Matrix(rows: 17, columns: 17)
        
        for (row,i) in distances.enumerated() {
            for (column,j) in distances.enumerated() {
                let x = halfWidth + (halfWidth * j)
                let y = halfHeight + (halfHeight * i)
                
                var greyValue = 0
                var blurValue = 0
                var hiddenValue = 0
                var colorValue = 0
                for o in customViewList{
                    if o.frame.contains(CGPoint(x: x, y: y)){
                        
                        if(o.blur.blurRadius > 0) {
                            blurValue += o.viewValue
                        }
                        
                        if(o.blur.backgroundColor == UIColor.black){
                            greyValue += o.viewValue
                        }
                        
                        if(o.isLinkedToImage){
                            if(o.alphaValue == 0) {
                                hiddenValue = hiddenValue + 10
                            }
                        }
                        if(o.image != nil) {
                            colorValue += o.viewValue
                        }
                    }
                }
                
                blurGrid[row,column] = blurValue + blurGrid[row,column]
                greyGrid[row,column] = greyValue + greyGrid[row,column]
                hiddenGrid[row,column] = hiddenValue + hiddenGrid[row,column]
                colorGrid[row,column] = hiddenValue + hiddenGrid[row,column]
            }
        }
        
        let screenShotFile = FileObject(name: "\(subjectId)_screenshot_\(self.getTodayString())_\(exportCount)", type: FileType.PNG)
        let blurPointsFile = FileObject(name:"\(subjectId)_blurPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        let greyPointsFile = FileObject(name:"\(subjectId)_greyPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        let hiddenPointsFile = FileObject(name:"\(subjectId)_hiddenPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        let ColorPointsFile = FileObject(name:"\(subjectId)_hiddenPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        
        
        screenShotFile.savePNG(view: mainView)
        blurPointsFile.saveCSV(grid:blurGrid)
        greyPointsFile.saveCSV(grid:greyGrid)
        hiddenPointsFile.saveCSV(grid:hiddenGrid)
        ColorPointsFile.saveCSV(grid: colorGrid)
        
        savedFiles = [screenShotFile,blurPointsFile,greyPointsFile,hiddenPointsFile, ColorPointsFile]
    }
    
    func uploadFile(file:FileObject,completion:@escaping (_ uploaded:Bool, _ error:Error?)-> Void){
        let contentClient : BOXContentClient = BOXContentClient.default()
        let fileData : Data
        
        do {
            fileData = try Data(contentsOf:file.path)
            let uploadRequest  : BOXFileUploadRequest = contentClient.fileUploadRequestToFolder(withID: "41017077987", from: fileData, fileName: file.name)
            uploadRequest.perform(progress: { (_ totalBytesTransferred:Int64, _ totalBytesExpectedToTransfer:Int64) in
            }, completion: { (_ boxFile:BOXFile?, _ boxError:Error?) in
                
                if let fileError = boxError {
                    completion(false,fileError)
                } else {
                    completion(true, nil)
                }
                
            })
        } catch {
            completion(false,error)
        }
        
    }
    
    func boxAuthorize(){
        BOXContentClient.default().authenticate(completionBlock: { (user:BOXUser?, error:Error?) in
            if (error == nil )
            {
                print((user?.login!)! as String)
            }
        })
        
    }
    
    private func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(format: "%02d",month!) + "-" + String(format: "%02d",day!) + " " + String(format: "%02d",hour!)  + "-" + String(format: "%02d",minute!) + "-" +  String(format: "%02d",second!)
        
        return today_string
        
    }
    
}
