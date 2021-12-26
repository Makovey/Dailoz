//
//  Task.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 02.12.2021.
//

import Foundation

struct Task: Hashable {
    
    init(title: String, dateBegin: Date, startAt: Date, endTo: Date, type: String?, description: String?) {
        self.id = UUID().uuidString
        self.title = title
        self.dateBegin = dateBegin
        self.startAt = startAt
        self.endTo = endTo
        self.type = type
        self.description = description
    }
    
    init(id: String, title: String, dateBegin: Date, startAt: Date, endTo: Date, type: String?, description: String?) {
        self.id = id
        self.title = title
        self.dateBegin = dateBegin
        self.startAt = startAt
        self.endTo = endTo
        self.type = type
        self.description = description
    }
    
    let id: String
    let title: String
    let dateBegin: Date
    let startAt: Date
    let endTo: Date
    let type: String?
    let description: String?
}
