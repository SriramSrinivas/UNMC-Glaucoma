//
//  PersistanceService.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/8/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//


import Foundation
import CoreData

final class PersistanceService {
    
    // MARK: - Core Data stack
    
    private init() {}
    static let shared = PersistanceService()
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "glacInit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    //lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support
    
    static func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    static func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            return [T]()
        }
    }
    
}
