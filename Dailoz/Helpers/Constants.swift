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
    static let profileSegue = "profileToType"
    static let taskSegue = "tableToTask"
    static let homeSegue = "homeToDone"
    static let welcomeSegue = "welcomeToMain"
    static let splashSegue = "splashToWelcome"
    
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
            static let isDone = "isDone"
            static let isNeededRemind = "isNeededRemind"
        }

    }
    
    struct Color {
        static let mainPurple = UIColor.init(named: "MainPurple")!
        static let purpleTypeBirght = UIColor.init(named: "purpleTypeText")!
        static let purpleType = UIColor.init(named: "purpleCellBackground")!
        static let greenTypeBright = UIColor.init(named: "greenTypeText")!
        static let greenType = UIColor.init(named: "greenCellBackground")!
        static let orangeTypeBright = UIColor.init(named: "orangeTypeText")!
        static let orangeType = UIColor.init(named: "orangeCellBackground")!
        static let blueTypeBright = UIColor.init(named: "blueTypeText")!
        static let blueType = UIColor.init(named: "blueCellBackground")!
        static let graphic = UIColor.init(named: "GraphicBackground")!
        static let mainBlue = UIColor.init(named: "MainBlue")!
        static let red = UIColor(red: 231/255, green: 1245/255, blue: 125/255, alpha: 1)
    }
    
    struct Cell {
        static let taskCell = "TaskCell"
        static let tagCell = "TagCell"
    }
}
