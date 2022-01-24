//
//  AddTaskScreen.swift
//  DailozUITests
//
//  Created by MAKOVEY Vladislav on 24.01.2022.
//

import XCTest

struct AddTaskScreen {
    
    let app: XCUIApplication!
    
    func tabBarItemSelected() -> XCUIElement {
        return app.tabBars["Tab Bar"].buttons["plus.circle.fill"]
    }

    func tabBarItem() -> XCUIElement {
        return app.tabBars["Tab Bar"].buttons["add"]
    }
    
    func findLabelWithText(_ text: String) -> XCUIElement {
        return app.staticTexts[text]
    }
    
    func createButton() -> XCUIElement {
        return app.buttons["Create"]
    }
}
