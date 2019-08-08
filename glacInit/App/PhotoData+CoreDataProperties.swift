//
//  PhotoData+CoreDataProperties.swift
//  
//
//  Created by Lyle Reinholz on 8/8/19.
//
//

import Foundation
import CoreData


extension PhotoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoData> {
        return NSFetchRequest<PhotoData>(entityName: "PhotoData")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?

}
