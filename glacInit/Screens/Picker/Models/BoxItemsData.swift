//
//  BoxItemsData.swift
//  
//
//  Created by Lyle Reinholz on 7/22/19.
//

import Foundation
import BoxContentSDK

struct hello {
    let hello: [BoxItemsData]
}

struct BoxItemsData {
    var isSelected: Bool
    let name: String
    let ID: String
    let isFolder: Bool
    init(boxItem: BOXItem) {
        self.isSelected = false
        self.name = boxItem.name
        self.ID = boxItem.modelID
        self.isFolder = boxItem.isFolder
    }
    init(name: String, id: String){
        self.name = name
        self.ID = id
        self.isFolder = false
        self.isSelected = false
    }
}
