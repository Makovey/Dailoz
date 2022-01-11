//
//  Task.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 02.12.2021.
//

import Foundation

struct Task: Hashable {
    
    init(title: String, dateBegin: Date, startAt: Date, until: Date, type: String?, description: String?, isNeededRemind: Bool) {
        self.id = UUID().uuidString
        self.title = title
        self.dateBegin = dateBegin
        self.startAt = startAt
        self.until = until
        self.type = type
        self.description = description
        self.isDone = false
        self.isNeededRemind = isNeededRemind
    }
    
    init(id: String, title: String, dateBegin: Date, startAt: Date, until: Date, type: String?, description: String?, isDone: Bool, isNeededRemind: Bool) {
        self.id = id
        self.title = title
        self.dateBegin = dateBegin
        self.startAt = startAt
        self.until = until
        self.type = type
        self.description = description
        self.isDone = isDone
        self.isNeededRemind = isNeededRemind
    }
    
    let id: String
    let title: String
    var dateBegin: Date
    var startAt: Date
    var until: Date
    var type: String?
    var description: String?
    var isDone: Bool
    var isNeededRemind: Bool
}
