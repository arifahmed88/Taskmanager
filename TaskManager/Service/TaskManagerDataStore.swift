//
//  TaskManagerDataStore.swift
//  TaskManager
//
//  Created by ArifAhmed on 29/6/24.
//

import Foundation
import CoreData

class TaskManagerDataStore: TaskManagerServiceProtocol {
    
    private let context: NSManagedObjectContext
    private let coreDataStack: CoreDataStack
    
    init(context: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.context = context
        self.coreDataStack = coreDataStack
    }
    
    
    func fetchTask(completion: @escaping ([TaskCoreDataInfo]) -> Void) {
        let fetchTaskRequest: NSFetchRequest<TaskCoreDataInfo> = TaskCoreDataInfo.fetchRequest()
        do {
            let matches = try context.fetch(fetchTaskRequest)
            
            completion(matches.sorted(by: { $0.dueDate ?? Date() < $1.dueDate ?? Date() }))
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func addTask(taskInfo: TaskDataModel) -> TaskCoreDataInfo {
        
        let taskInfoDB = TaskCoreDataInfo(context: context)
        taskInfoDB.uniqueID = taskInfo.uniqueID
        taskInfoDB.title = taskInfo.title
        taskInfoDB.taskDescription = taskInfo.description
        taskInfoDB.dueDate = taskInfo.dueDate
        taskInfoDB.isChecked = taskInfo.isChecked
        coreDataStack.save(context)
        return taskInfoDB
    }
    
    @discardableResult
    func updateTask(taskinfo: TaskCoreDataInfo) -> TaskCoreDataInfo {
        coreDataStack.save(context)
        return taskinfo
    }
    
    func deleteTask(uniqueID: String?) {
        
        if let id = uniqueID{
            let request = TaskCoreDataInfo.fetchRequest()
            request.predicate = NSPredicate(format: "uniqueID = %@", id)
            
            do {
                let result = try context.fetch(request)
                for object in result {
                    context.delete(object)
                }
                coreDataStack.save(context)
            }
            catch {
                print("Saved task remove error = \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func deleteAllTask() {
        let request = TaskCoreDataInfo.fetchRequest()
        do {
            let result = try context.fetch(request)
            for object in result {
                context.delete(object)
            }
            coreDataStack.save(context)
        }
        catch {
            print("Saved task remove error = \(error.localizedDescription)")
        }
    }
}
