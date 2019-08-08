//
//  SavedFileData+CoreDataProperties.swift
//  
//
//  Created by Lyle Reinholz on 8/8/19.
//
//

import Foundation
import CoreData


extension SavedFileData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedFileData> {
        return NSFetchRequest<SavedFileData>(entityName: "SavedFileData")
    }

    @NSManaged public var name: String?
    @NSManaged public var data: String?

}
