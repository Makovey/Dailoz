//
//  Task.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 02.12.2021.
//

import Foundation

struct Task: Hashable {
    
    init(title: String, dateBegin: Date, startAt: Date, endTo: Date, description: String?) {
        self.id = UUID().uuidString
        self.title = title
        self.dateBegin = dateBegin
        self.startAt = startAt
        self.endTo = endTo
        self.description = description
    }
    
    init(id: String, title: String, dateBegin: Date, startAt: Date, endTo: Date, description: String?) {
        self.id = id
        self.title = title
        self.dateBegin = dateBegin
        self.startAt = startAt
        self.endTo = endTo
        self.description = description
    }
    
    let id: String
    let title: String
    let dateBegin: Date
    let startAt: Date
    let endTo: Date
    let description: String?
}
