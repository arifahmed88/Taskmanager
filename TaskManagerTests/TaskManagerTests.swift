//
//  TaskManagerTests.swift
//  TaskManagerTests
//
//  Created by ArifAhmed on 27/6/24.
//

import XCTest
@testable import TaskManager

final class TaskManagerTests: XCTestCase {

    var sut: TaskManagerDataStore!
    var coreDataStack: TestCoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        sut = TaskManagerDataStore(context: coreDataStack.viewContext, coreDataStack: coreDataStack
        )
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        coreDataStack = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func testAddtaskModel() {
        
        let id = UUID().uuidString
        let date = Date()
        let dateFormatter = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        let task = TaskDataModel(id: id, title: "Add Testing", description: "Add Testing is Going on", dueDate: date, isChecked: false)
        
        let newTask = sut.addTask(taskInfo: task)
        
        XCTAssertNotNil(newTask, "Task should not nil")
        XCTAssert(newTask.title == "Add Testing", "Task title should be Add Testing")
        XCTAssert(newTask.taskDescription == "Add Testing is Going on", "Task description should be Add Testing is Going on")
        XCTAssert(newTask.dueDate == date, "task due date should be \(dateFormatter)")
        XCTAssert(newTask.isChecked == false, "task should be unchecked")
    }
    
    
    func testBackgroundContextToSaveTask() {
        let backgroundContext = coreDataStack.backgroundContext()
        sut = TaskManagerDataStore(
            context: backgroundContext,
            coreDataStack: coreDataStack
        )
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: backgroundContext)
        
        backgroundContext.perform {
            let id = UUID().uuidString
            let date = Date()
            let dateFormatter = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            let task = TaskDataModel(id: id, title: "Testing", description: "Testing is Going on", dueDate: date, isChecked: false)
            let newTask = self.sut.addTask(taskInfo: task)
            
            XCTAssertNotNil(newTask, "new task value should not nil")
        }
        
        waitForExpectations(timeout: 2.0) { (error: Error?) in
            XCTAssertNil(error, "Error should not exist")
        }
    }
    

    func testFetchTask() {
        let id = UUID().uuidString
        let date = Date()
        let task = TaskDataModel(id: id, title: "Testing1", description: "testiing is Going on", dueDate: date, isChecked: false)
        let firstTask = sut.addTask(taskInfo: task)
        
        sut.fetchTask(completion: { (tasks: [TaskCoreDataInfo]) in
            XCTAssertNotNil(tasks, "Task should not nil")
            XCTAssert(!tasks.isEmpty, "Task should not empty")
            XCTAssert(tasks.first == firstTask, "Task should be same")
        })
    }
    
    func testUpdatetask() {
        
        let id = UUID().uuidString
        let date = Date()
        let task = TaskDataModel(id: id, title: "Testing2", description: "testing2 is Going on", dueDate: date, isChecked: false)
        let initialtask = sut.addTask(taskInfo: task)
        let dateFormatter = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        
        XCTAssertNotNil(initialtask, "Task should not nil")
        XCTAssert(initialtask.title == "Testing2", "Task title should be Testing2")
        XCTAssert(initialtask.taskDescription == "testing2 is Going on", "Task description should be testing2 is Going on")
        XCTAssert(initialtask.dueDate == date, "task due date should be \(dateFormatter)")
        XCTAssert(initialtask.isChecked == false, "task should be unchecked")
        
        
        initialtask.title = "Testing2 updated"
        initialtask.taskDescription = "testing2 updating is Going on"
        initialtask.isChecked = true
        let updatedTask = sut.updateTask(taskinfo: initialtask)
        
        XCTAssertNotNil(updatedTask, "task should not be nil")
        XCTAssert(updatedTask.title == "Testing2 updated", "task title should Testing2 updated")
        XCTAssert(updatedTask.taskDescription == "testing2 updating is Going on", "task description should testing2 updating is Going on")
        XCTAssert(initialtask.isChecked == true, "task should be checked")
    }
    
    func testDeleteTask() {
        let id = UUID().uuidString
        let date = Date()
        let dateFormatter = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        let task = TaskDataModel(id: id, title: "Delete Testing", description: "Delete Testiing is Going on", dueDate: date, isChecked: false)
        let newTask = sut.addTask(taskInfo: task)
        
        XCTAssertNotNil(newTask, "Task should not nil")
        XCTAssert(newTask.title == "Delete Testing", "Task title should be Delete Testing")
        XCTAssert(newTask.taskDescription == "Delete Testiing is Going on", "Task description should be Delete Testiing is Going on")
        XCTAssert(newTask.dueDate == date, "task due date should be \(dateFormatter)")
        XCTAssert(newTask.isChecked == false, "task should be unchecked")
        
        sut.fetchTask(completion: {tasks in
            XCTAssert(!tasks.isEmpty, "tasks should not empty")
        })
        
        sut.deleteTask(uniqueID: newTask.uniqueID)
        
        sut.fetchTask(completion: {tasks in
            XCTAssert(tasks.isEmpty, "tasks should empty")
        })
    }

}
