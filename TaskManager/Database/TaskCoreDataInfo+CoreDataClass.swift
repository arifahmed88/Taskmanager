//
//  TaskCoreDataInfo+CoreDataClass.swift
//  TaskManager
//
//  Created by ArifAhmed on 28/6/24.
//
//


import Foundation
import CoreData

@objc(TaskCoreDataInfo)
public class TaskCoreDataInfo: NSManagedObject {
    
    class func addNewElement(taskInfo: TaskDataModel) {
        
        if let context = DatabaseHelper.getContext(){
            
            do {
                let taskInfoDB = TaskCoreDataInfo(context: context)
                taskInfoDB.uniqueID = taskInfo.uniqueID
                taskInfoDB.title = taskInfo.title
                taskInfoDB.taskDescription = taskInfo.description
                taskInfoDB.dueDate = taskInfo.dueDate
                try context.save()
            }
            catch {
                print("New task Add error = \(error.localizedDescription)")
            }
            
        }
    }
    
    
    class func updateElement(taskInfo: TaskDataModel) {
        
        if let context =  DatabaseHelper.getContext(){
            let request = TaskCoreDataInfo.fetchRequest()
            request.predicate = NSPredicate(format: "uniqueID = %@", taskInfo.uniqueID)
            
            do {
                let result = try context.fetch(request)
                if result.count > 0{
                    let taskInfoDB = result[0]
                    taskInfoDB.title = taskInfo.title
                    taskInfoDB.taskDescription = taskInfo.description
                    taskInfoDB.dueDate = taskInfo.dueDate
                } else {
                    print("Saved task update data not found")
                }
                
                try context.save()
            }
            catch {
                print("Saved task update error = \(error.localizedDescription)")
            }
        }
       
            
    }
    
    
    @objc static func fetchAllDrafts() -> [TaskCoreDataInfo]? {
        
        if let context =  DatabaseHelper.getContext(){
            let request: NSFetchRequest<TaskCoreDataInfo> = TaskCoreDataInfo.fetchRequest()
            do {
                let matches = try context.fetch(request)
                return matches.sorted(by: { $0.dueDate ?? Date() < $1.dueDate ?? Date() })
            } catch {
                print("fetching error")
            }
        }
        
        
        return nil
    }

    
    
    class func deleteItem(uuid:String?){
        
        if let context =  DatabaseHelper.getContext(), let id = uuid{
            let request = TaskCoreDataInfo.fetchRequest()
            request.predicate = NSPredicate(format: "uniqueID = %@", id)
            
            do {
                let result = try context.fetch(request)
                for object in result {
                    context.delete(object)
                }
                
                do{
                    try context.save()
                }
                catch{
                    print("Saved task remove error = \(error.localizedDescription)")
                }
            }
            catch {
                print("Saved task remove error = \(error.localizedDescription)")
            }
            
        }
    }
    
    class func deleteAllItem(){
        
        if let context =  DatabaseHelper.getContext(){
            
            let request = TaskCoreDataInfo.fetchRequest()
            do {
                let result = try context.fetch(request)
                for object in result {
                    context.delete(object)
                }
                do{
                    try context.save()
                }
                catch{
                    print("Saved task remove error = \(error.localizedDescription)")
                }
            }
            catch {
                print("Saved task remove error = \(error.localizedDescription)")
            }
        }
    }
    
    

}
