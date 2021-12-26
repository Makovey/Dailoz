//
//  Constants.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 27.11.2021.
//

import UIKit

struct K {
    static let loginSegue = "loginToMain"
    static let signUpSegue = "signUpToMain"
    
    static let mainFont = "Comfortaa"
    static let mainFontBolt = "Comfortaa-Bold"
    
    struct FStore {
        struct Collection {
            static let userInfo = "userInfo"
            static let tasks = "tasks"
            static let userTasks = "userTasks"
        }
        
        struct Field {
            static let uid = "uid"
            static let email = "email"
            static let name = "name"
            
            static let id = "id"
            static let title = "title"
            static let date = "date"
            static let start = "start"
            static let end = "end"
            static let type = "type"
            static let description = "description"
        }

    }
    
    struct Color {
        static let mainPurple = UIColor(red: 91/255, green: 103/255, blue: 202/255, alpha: 1)
        static let red = UIColor(red: 231/255, green: 1245/255, blue: 125/255, alpha: 1)
    }
    
    struct Cell {
        static let taskCell = "TaskCell"
        static let tagCell = "TagCell"
    }
}
