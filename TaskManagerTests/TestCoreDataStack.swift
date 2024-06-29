//
//  TestCoreDataStack.swift
//  TaskManager
//
//  Created by ArifAhmed on 29/6/24.
//

@testable import TaskManager
import CoreData

class TestCoreDataStack: CoreDataStack {

    override init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let testPersistentContainer = NSPersistentContainer(name: CoreDataStack.modelName)
        testPersistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        testPersistentContainer.loadPersistentStores { (_, error: Error?) in
            if let _ = error {
                fatalError()
            }
        }
        
        persistentContainer = testPersistentContainer
    }
    
}
