//
//  CoreDataStack.swift
//  EventPlannerExam
//
//  Created by James Lea on 4/30/21.
//

import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "EventPlannerExam")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { container.viewContext }
    
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
//    static func deleteAndRebuild() {
//        try! container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: , options: nil)
//        
//        loadStores()
//    }
    
} //End of enum
