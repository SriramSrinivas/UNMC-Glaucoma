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


// alright will now need to pass the data off
// need to make a picker view for the data
// allow the user to select multiple files
// load all csv files on the screen
//make a model for both folders and files maybe not refer down below
// brain Vong has cool vids for the picker view
// start cleaning up code that is making this messy
// be cool and stay in school XD

// maybe just make box items to begin with and see if you can work with that 


import Foundation
import BoxContentSDK
//import NotificationCenter
// init will get the data needed from the user
//protocol TransferDataDelegate {
//    func transferData(folderitems: Array<BOXItem>)
//}
protocol ImportDelegate: class {
    func didReceiveData(boxItems: [BOXItem])
}
class importFile {
    
    weak var delegate: ImportDelegate?
    var subjectId: String
    var backGroundId: String
    //var date: Date
     var type: FileType
    var path = "/GlacInit/"
    var fileURL : URL?
    let stream = OutputStream()
    var fileName = "NewFile" + ".csv"
    var csvText = ""
    var items = Array<Any>()
//    var delegate: TransferDataDelegate?
    //var help = TransferDataDelegate?.self
    
    init(subjectId: String, backGroundId: String, file: FileType) {
        self.subjectId = subjectId
        self.backGroundId = backGroundId
        //self.date = date
        self.type = file
       // self.path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(subjectId)")!
    }
    
// sets the background
    func newFile(){
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
        }
    }
    func setBackGround() -> String{
        return backGroundId
    }
    
    func boxAuthorize(){
        BOXContentClient.default().authenticate(completionBlock: { (user:BOXUser?, error:Error?) in
            if (error == nil )
            {
                print((user?.login!)! as String)
            }
        })
        
    }
// method to get the files from box
    func getFolderItems(withID: String){
       
        
        let contentClient = BOXContentClient.default()
        let boxfolderrequest = contentClient?.folderItemsRequest(withID: withID)
        boxfolderrequest?.perform(completion: {(items: Array?, error: Error?) -> Void in
            //items?.first?.isFile
            //var delegate: TransferDataDelegate?
//            self.delegate?.transferData(folderitems: (items as! Array<BOXItem>))
            
            self.delegate?.didReceiveData(boxItems: items!)
            
            //Instance member 'transferData' cannot be used on type 'TransferDataDelegate'; did you mean to use a value of this type instead?
        })
    }
    func downLoadFile(){
        newFile()
        let contentClient = BOXContentClient.default()

        let boxRequest = contentClient?.fileDownloadRequest(withID: "489481746578", toLocalFilePath: fileURL?.path)
        //let boxReq = contentClient?.searchRequest(withQuery: "dog_mainTes_blurPoints_2019-07-11 11-11-32_1.csv", in: NSRange(location: 2, length: 100))

        boxRequest?.perform(progress: { (_ totalBytesTransferred:Int64, _ totalBytesExpectedToTransfer:Int64) in
        }, completion: {(_ error: Error?) -> Void in

        })
        let data: Data
 
    }
    
    func downloadedFile() -> URL {
        return fileURL!
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
