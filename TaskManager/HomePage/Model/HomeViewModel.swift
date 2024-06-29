//
//  TaskDataListInfo.swift
//  TaskManager
//
//  Created by ArifAhmed on 28/6/24.
//

import Foundation

class HomeViewModel{
    private var tasksDataList:[TaskCoreDataInfo] = []
    var service:TaskManagerService
    
    init(){
        let coreDataStack = CoreDataStack()
        let restoDataStore = TaskManagerDataStore(context: coreDataStack.viewContext, coreDataStack: coreDataStack)
        service = TaskManagerService(dataStore: restoDataStore)
    }
    
    func updateList(){
        service.fetchTask(completion: {[weak self] allTasks in
            self?.tasksDataList = allTasks
        })
    }
    
    func getTotalDataCount()->Int{
        return tasksDataList.count
    }
    
    func getData(index:Int)->TaskCoreDataInfo?{
        if index < 0 || index >= tasksDataList.count{
            return nil
        }
        return tasksDataList[index]
    }
    
    func removeItem(id:String){
        service.deleteTask(uniqueID: id)
        updateList()
    }
    
    func updateItemCheckState(isChecked:Bool, index:Int){
        if index < 0 || index >= tasksDataList.count{
            return
        }
        let previousData = tasksDataList[index]
        
        previousData.isChecked = isChecked
        service.updateTask(task: previousData)
        updateList()
    }
    
    func removeAllItem(){
        service.deleteAllTask()
        tasksDataList.removeAll()
        updateList()
    }
}
