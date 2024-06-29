//
//  TaskManagerService.swift
//  TaskManager
//
//  Created by ArifAhmed on 29/6/24.
//



import Foundation

protocol TaskManagerServiceProtocol {
    func fetchTask(completion: @escaping (_ menu: [TaskCoreDataInfo]) -> Void)
    func addTask(taskInfo: TaskDataModel) -> TaskCoreDataInfo
    func updateTask(taskinfo: TaskCoreDataInfo) -> TaskCoreDataInfo
    func deleteTask(uniqueID: String?)
    func deleteAllTask()
}

class TaskManagerService {
    
    private let dataStore: TaskManagerServiceProtocol
    
    init(dataStore: TaskManagerServiceProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchTask(completion: @escaping (_ menu: [TaskCoreDataInfo]) -> Void) {
        dataStore.fetchTask(completion: { (taskList: [TaskCoreDataInfo]) in
            DispatchQueue.main.async {
                completion(taskList)
            }
        })
    }
    
    func addTask(taskInfo: TaskDataModel) {
        _ = dataStore.addTask(taskInfo: taskInfo)
    }
    
    func updateTask(task: TaskCoreDataInfo) {
        _ = dataStore.updateTask(taskinfo: task)
    }
    
    func deleteTask(uniqueID: String?) {
        dataStore.deleteTask(uniqueID: uniqueID)
    }
    
    func deleteAllTask() {
        dataStore.deleteAllTask()
    }
}
