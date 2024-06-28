//
//  NSObject+Extention.swift
//  TaskManager
//
//  Created by ArifAhmed on 27/6/24.
//

import Foundation

extension NSObject {
    @objc var className: String {
        return String(describing: type(of: self))
    }
    @objc class var className: String {
        return String(describing: self)
    }
}
