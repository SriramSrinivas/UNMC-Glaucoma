//
//  VisaulFieldData+CoreDataProperties.swift
//  
//
//  Created by Lyle Reinholz on 8/8/19.
//
//

import Foundation
import CoreData


extension VisaulFieldData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisaulFieldData> {
        return NSFetchRequest<VisaulFieldData>(entityName: "VisaulFieldData")
    }

    @NSManaged public var name: String?
    @NSManaged public var data: String?

}
