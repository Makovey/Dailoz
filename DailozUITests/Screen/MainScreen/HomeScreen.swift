//
//  HomeScreen.swift
//  DailozUITests
//
//  Created by MAKOVEY Vladislav on 24.01.2022.
//

import XCTest

struct HomeScreen {
    
    let app: XCUIApplication!
    
    func tabBarItemSelected() -> XCUIElement {
        return app.tabBars["Tab Bar"].buttons["house.circle.fill"]
    }

    func tabBarItem() -> XCUIElement {
        return app.tabBars["Tab Bar"].buttons["house.circle"]
    }
    
    func findLabelWithText(_ text: String) -> XCUIElement {
        return app.staticTexts[text]
    }
}
