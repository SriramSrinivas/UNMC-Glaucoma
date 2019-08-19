//
//  SaveImageData+CoreDataProperties.swift
//  
//
//  Created by Lyle Reinholz on 8/16/19.
//
//

import Foundation
import CoreData


extension SaveImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveImageData> {
        return NSFetchRequest<SaveImageData>(entityName: "SaveImageData")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var id: Int16
    @NSManaged public var title: String?

}
