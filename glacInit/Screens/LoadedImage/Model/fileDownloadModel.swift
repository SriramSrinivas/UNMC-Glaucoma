//
//  fileDownloadModel.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/17/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//
//
//import Foundation
//
//
//struct root {
//    let items: [BOXItem]
//}

//struct folderItems: Codable {
//    var type: String
//    var id: String
//    var sequenceID: String
//    var name: String
//}
//
//struct folderListingViewModel {
//    let type: String
//    let id: String
//    let sequenceID: String
//    let name: [String.SubSequence]
//}
//extension folderListingViewModel {
//    init(folderitems: BOXItem) {
//        self.type = folderitems.type
//        self.id = folderitems.modelID
//        self.sequenceID = folderitems.sequenceID
//        let parts = folderitems.name.split(separator: "_")
//        self.name = parts
//        
//    }
//    
//    //MARK: TODO
//    
//    func checksName(name: [String.SubSequence]) -> [String.SubSequence] {
//        var retname = name
//        if name.count < 5 {
//            retname.insert("mainTes", at: 1)
//        }
//        else if name.count == 5 {
//            retname = name
//        }
//        else if name.count > 5 {
//            
//            
//        }
//        return retname
//    }
//}

