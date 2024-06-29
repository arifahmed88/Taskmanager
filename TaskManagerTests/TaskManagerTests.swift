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

    func testFetchTask() {
        let id = UUID().uuidString
        let date = Date()
        let task = TaskDataModel(id: id, title: "Testing1", description: "testiing is Going on", dueDate: date, isChecked: false)
        
        let firstTask = sut.addTask(taskInfo: task)
        
        sut.fetchTask(completion: { (tasks: [TaskCoreDataInfo]) in
            XCTAssertNotNil(tasks, "menu should not nil")
            XCTAssert(!tasks.isEmpty, "menu should not empty")
            XCTAssert(tasks.first == firstTask, "Menu should be same")
        })
    }

}
