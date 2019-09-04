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
import BoxContentSDK

enum effectAnchored {
    case isAnchored
    case NotAnchored
}
extension effectAnchored {
    init(flag: Bool) {
        if flag {
            self = .isAnchored
        } else {
            self = .NotAnchored
        }
    }
    init(flag: String) {
        if flag == "isAnchored"{
            self = .isAnchored
        } else {
            self = .NotAnchored
        }
    }
}

class Session {
    var subjectId: String
    var exportCount = 0
    var distances =  [CGFloat]()
    var savedFiles = [FileObject]()
    //amount of times box tried to upload a file
    var uploadAttempt = 0
    var csvFilesUploadedCount = 0
    var pngFilesUploadedCount = 0
    var fileURL : URL?
    var csvText = ""
    
//    private let context = (PersistanceService.shared.context)
    
    init(currentSubjectId: String) {
        distances = [ -1, -0.8098, -0.6494, -0.5095, -0.3839, -0.2679, -0.158, -0.05, 0, 0.05, 0.158, 0.2679, 0.3839, 0.5095, 0.6494, 0.8098, 1]
        subjectId = currentSubjectId
    }
    
    func saveGridData(mainView:UIView,customViewList:[CustomViewUpdate], hasBox: Bool){
        exportCount = exportCount + 1
        let width = mainView.frame.width
        let height = mainView.frame.height
        let halfWidth = width/2
        let halfHeight = height/2
        
        var blurGrid = Matrix(rows:17,columns:17)
        var greyGrid = Matrix(rows:17,columns:17)
        var hiddenGrid = Matrix(rows: 17, columns: 17)
        var colorGrid = Matrix(rows: 17, columns: 17)
        var csvText = ""
        
        for view in customViewList{
            let height = view.frame.height / mainView.frame.height
            let width = view.frame.width / mainView.frame.width
            let midX = view.frame.midX / mainView.frame.width
            let midY = view.frame.minY / mainView.frame.height
            let anchor = effectAnchored(flag: view.isLinkedToImage)
            csvText.append("\(view.effect),\(height),\(width),\(midX),\(midY),\(view.viewValue),\(anchor)\n")
        }
        
        
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
                        
                        if(o.blur.blurRadius > 0 && o.effect.contains(effectType.blur) ) {
                            blurValue += o.viewValue
                        }
                        
                        if(o.effect.contains(effectType.grey)){
                            greyValue += o.viewValue
                        }
                        
                        if(o.effect.contains(effectType.isHidden)){
                            if(o.alphaValue == 0) {
                                hiddenValue = hiddenValue + 10
                            }
                        }
                        if(o.effect.contains(effectType.color)) {
                            colorValue += o.viewValue
                        }
                    }
                }
                
                blurGrid[row,column] = blurValue + blurGrid[row,column]
                greyGrid[row,column] = greyValue + greyGrid[row,column]
                hiddenGrid[row,column] = hiddenValue + hiddenGrid[row,column]
                colorGrid[row,column] = colorValue + colorGrid[row,column]
            }
        }
        let name = Globals.shared.currentBackGround.title
        var saveFile = FileObject(name: "\(subjectId)_\(name!)_saveFile_\(self.getTodayString())_\(exportCount)", type: FileType.CSV)
        let screenShotFile = FileObject(name: "\(subjectId)_\(name!)_screenshot_\(self.getTodayString())_\(exportCount)", type: FileType.PNG)
        var blurPointsFile = FileObject(name:"\(subjectId)_\(name!)_blurPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        var greyPointsFile = FileObject(name:"\(subjectId)_\(name!)_greyPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        var hiddenPointsFile = FileObject(name:"\(subjectId)_\(name!)_hiddenPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        var ColorPointsFile = FileObject(name:"\(subjectId)_\(name!)_colorPoints_\(getTodayString())_\(exportCount)",type:FileType.CSV)
        
        saveDataToFile(file: csvText, fileName: "\(subjectId)_\(name!)_saveFile_\(self.getTodayString())_\(exportCount)")
        
        saveFile.path = fileURL!
        screenShotFile.savePNG(view: mainView)
        blurPointsFile.saveCSV(grid:blurGrid)
        greyPointsFile.saveCSV(grid:greyGrid)
        hiddenPointsFile.saveCSV(grid:hiddenGrid)
        ColorPointsFile.saveCSV(grid: colorGrid)
        
        let data = NSData(contentsOf: screenShotFile.path)!
        
        if Globals.shared.importAndExportLoaction == dataSource.local {
            let localStor = LoaclStorage.init()
            localStor.SaveFileToLocal(name: saveFile.name, blurdata: blurPointsFile.Matrix!, colordata: ColorPointsFile.Matrix!, greydata: greyPointsFile.Matrix!, hiddendata: hiddenPointsFile.Matrix!, savedata: csvText, image: data)
        }
        
        savedFiles = [screenShotFile,blurPointsFile,greyPointsFile,hiddenPointsFile, ColorPointsFile, saveFile]
    }
    
  
    
    func uploadFile(file:FileObject, FolderID: String ,completion:@escaping (_ uploaded:Bool, _ error:Error?)-> Void){
        let contentClient : BOXContentClient = BOXContentClient.default()
        let fileData : Data
        
        do {
            fileData = try Data(contentsOf:file.path)
            //contentClient.folder
            //contentClient.search
            //MARK: noteworthy
            //folder ID is where the files will be loaded and I got it from the inspect of the box profile and get the ID folder
            let uploadRequest  : BOXFileUploadRequest = contentClient.fileUploadRequestToFolder(withID: FolderID, from: fileData, fileName: file.name)
            //contentClient.fileu
            //41017077987
            uploadRequest.perform(progress: { (_ totalBytesTransferred:Int64, _ totalBytesExpectedToTransfer:Int64) in
            }, completion: { (_ boxFile:BOXFile?, _ boxError:Error?) in
                
                if let fileError = boxError {
                    completion(false,fileError)
                    print(fileError)
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
    
    
    func saveDataToFile(fileName: FileObject, isSaveFile: Bool){
        let newfile = fileName
        let path = "/\(Globals.shared.getDate())/"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var fileURL = dir.appendingPathComponent(path)
            do{
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
                fileURL = dir.appendingPathComponent(path + "fileName.name")
            }
            catch{
                print("Unable to create directory \(Error.self)")
            }
            self.fileURL = fileURL
            
            do {
                //newfile.Matrix
                try newfile.Matrix?.write(to: fileURL, atomically: true, encoding: .utf8)
                
            } catch {
                
                print("\(error)")
                
            }
            
        }
    }
    func saveDataToFile(file: String, fileName: String){
        let newfile = fileName
        let path = "/\(Globals.shared.getDate())/"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var fileURL = dir.appendingPathComponent(path)
            do{
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
                fileURL = dir.appendingPathComponent(path + fileName)
            }
            catch{
                print("Unable to create directory \(Error.self)")
            }
            self.fileURL = fileURL
            
            do {
                
                try file.write(to: fileURL, atomically: true, encoding: .utf8)
                
            } catch {
                
                print("\(error)")
                
            }
            
        }
    }
    
}
