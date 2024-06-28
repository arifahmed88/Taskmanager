//
//  DatabaseHelper.swift
//  TaskManager
//
//  Created by ArifAhmed on 28/6/24.
//

import UIKit
import CoreData

class DatabaseHelper{
    
     static func getContext()-> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
}
