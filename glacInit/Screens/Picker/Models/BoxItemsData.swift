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
