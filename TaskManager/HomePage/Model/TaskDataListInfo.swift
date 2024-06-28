//
//  TaskDataListInfo.swift
//  TaskManager
//
//  Created by ArifAhmed on 28/6/24.
//

import Foundation

class TaskDataListInfo{
    private var tasksDataList:[TaskCoreDataInfo] = []
    
    init(){}
    
    func updateList(){
        tasksDataList = TaskCoreDataInfo.fetchAllDrafts() ?? []
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
        TaskCoreDataInfo.deleteItem(uuid: id)
        updateList()
//        tasksDataList.remove(at: index)

        
    }
    
    func removeAllItem(){
        TaskCoreDataInfo.deleteAllItem()
        tasksDataList.removeAll()
        updateList()
    }
}
