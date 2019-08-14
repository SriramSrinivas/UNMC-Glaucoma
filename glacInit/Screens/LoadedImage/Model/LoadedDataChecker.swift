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



//checks to make sure that the data that is going to be processed is in fact good data
// trows false if the file is not in expected format or is not in correct size
// allows app not to process bad data
    
    func checksDataForErrors(newData: [[String]]) -> Bool {
        if newData.count > 19 {
            return false
        }
        if newData.count < 17 {
            return false
        }
        var countrows = 0
        for rows in newData {
            
            if rows.count > 19 {
                return false
            }
            if rows.count < 17 {
                return false
            }
            var column = 0
            for datum in rows{
                //let double = Double(datum)
                let int = Int(datum)
                if  countrows == 0{
                    
                } else if (column == 0){
                    
                } else if (int != nil) {
                    if (int! < 0){
                        return false
                    }
                } else {
                    return false
                }
                column = column + 1
            }
            countrows = 1
        }
        return true
    }

