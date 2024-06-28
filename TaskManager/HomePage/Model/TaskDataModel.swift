//
//  TaskDataModel.swift
//  TaskManager
//
//  Created by ArifAhmed on 27/6/24.
//

import Foundation

class TaskDataModel{
    var uniqueID:String
    var title:String
    var description:String
    var dueDate:Date
    var isChecked:Bool
    
    init(id:String = UUID().uuidString,title: String, description: String, dueDate: Date, isChecked:Bool = false) {
        self.uniqueID = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isChecked = isChecked
    }
}
