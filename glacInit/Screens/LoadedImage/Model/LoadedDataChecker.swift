//
//  SavedDataChecker.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/8/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

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

