//
//  CoreDataStack.swift
//  TaskManager
//
//  Created by ArifAhmed on 29/6/24.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let modelName = "TaskManager"
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        container.loadPersistentStores { (_, error: Error?) in
            if let error = error {
                fatalError("\(error.localizedDescription)")
            }
        }
        return container
    }()
    
    public lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    public func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    public func save() {
        save(viewContext)
    }
    
    public func save(_ context: NSManagedObjectContext) {
        guard context == viewContext else {
            saveBackgroundContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("\(error.localizedDescription)")
            }
        }
    }
    
    public func saveBackgroundContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("\(error.localizedDescription)")
            }
            
            self.save(self.viewContext)
        }
    }
}
