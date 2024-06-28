//
//  TaskCoreDataInfo+CoreDataProperties.swift
//  TaskManager
//
//  Created by ArifAhmed on 28/6/24.
//
//

import Foundation
import CoreData


extension TaskCoreDataInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreDataInfo> {
        return NSFetchRequest<TaskCoreDataInfo>(entityName: "TaskCoreDataInfo")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var uniqueID: String?
    @NSManaged public var isChecked: Bool

}

extension TaskCoreDataInfo : Identifiable {

}
