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

import Foundation
import UIKit
import BoxContentSDK
//import NotificationCenter
// init will get the data needed from the user
//protocol TransferDataDelegate {
//    func transferData(folderitems: Array<BOXItem>)
//}
protocol ImportDelegate: class {
    func didReceiveData(boxItems: [BOXItem])
    func FileInfoReceived()
}
class importFile {
    
    weak var delegate: ImportDelegate?
    var path = "/GlacInit/"
    var fileURL : URL?
    let stream = OutputStream()
    var fileName: String?
    var items = Array<Any>()

    
    init() {
    }
    
    func newFile(withId: String){
        fileName = withId
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var fileURL = dir.appendingPathComponent(path)
            do{
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
                fileURL = dir.appendingPathComponent(path + fileName!)
            }
            catch{
                print("Unable to create directory \(Error.self)")
            }
            self.fileURL = fileURL
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
    //check for internet
// method to get the files from box
    func getFolderItems(withID: String, completion:@escaping (_ uploaded:Bool, _ error:Error?)-> Void){
        let contentClient = BOXContentClient.default()
        let boxfolderrequest = contentClient?.folderItemsRequest(withID: withID)
        boxfolderrequest?.perform(completion: {(items: Array?, error: Error?) in

            if let folerError = error {
                
                completion(false, folerError)
                print(folerError)
            } else {
                completion(true, nil)
                self.delegate?.didReceiveData(boxItems: items!)
            }
            
            //self.delegate?.didReceiveData(boxItems: items!)
      
        })
    }
    func downLoadFile(withId: String, completion:@escaping (_ uploaded:Bool, _ error:Error?)-> Void) -> URL{
        newFile(withId: withId)
        let contentClient = BOXContentClient.default()

        let boxRequest = contentClient?.fileDownloadRequest(withID: withId, toLocalFilePath: fileURL?.path)
       
        boxRequest?.perform(progress: { (_ totalBytesTransferred:Int64, _ totalBytesExpectedToTransfer:Int64) in
        }, completion: {(_ error: Error?) in
            
            if let folerError = error {
                
                completion(false, folerError)
                print(folerError)
            } else {
                completion(true, nil)
            }
            
        })
        return fileURL!
    }
    
//    func createBoxFoler(withName: String, parentFolderID: String){
//        let contentClient = BOXContentClient.default()
//        contentClient?.folderCreateRequest(withName: "NewFolder", parentFolderID: "0")
//        contentClient?.p
//        
//    }
//    [folderCreateRequest performRequestWithCompletion:^(BOXFolder *folder, NSError *error) {
//    // If successful, folder will be non-nil and represent the newly created folder on Box; otherwise, error will be non-nil.
//    }];
    
   
}
