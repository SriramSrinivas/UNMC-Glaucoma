//
//  VisaulFieldData+CoreDataProperties.swift
//  
//
//  Created by Lyle Reinholz on 8/9/19.
//
//

import Foundation
import CoreData


extension VisaulFieldData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisaulFieldData> {
        return NSFetchRequest<VisaulFieldData>(entityName: "VisaulFieldData")
    }

    @NSManaged public var name: String?
    @NSManaged public var blurdata: String?
    @NSManaged public var colordata: String?
    @NSManaged public var greydata: String?
    @NSManaged public var savedata: String?
    @NSManaged public var image: NSData?

}
