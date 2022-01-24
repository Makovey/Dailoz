//
//  ProfileScreen.swift
//  DailozUITests
//
//  Created by MAKOVEY Vladislav on 24.01.2022.
//

import XCTest

struct ProfileScreen {
    
    let app: XCUIApplication!
    
    func tabBarItemSelected() -> XCUIElement {
        return app.tabBars["Tab Bar"].buttons["Contact Photo"]
    }

    func tabBarItem() -> XCUIElement {
        return app.tabBars["Tab Bar"].buttons["person.circle"]
    }
    
    func logoutButton() -> XCUIElement {
        return app.buttons["logoutIcon"]
    }
    
    func findLabelWithText(_ text: String) -> XCUIElement {
        return app.staticTexts[text]
    }
    
}
