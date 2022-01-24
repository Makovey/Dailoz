//
//  LoginScreen.swift
//  DailozUITests
//
//  Created by MAKOVEY Vladislav on 24.01.2022.
//

import XCTest

struct LoginScreen {
    
    let app: XCUIApplication!
    
    func emailTextField() -> XCUIElement {
        return app.textFields["Email ID"]
    }
    
    func passwordTextField() -> XCUIElement {
        return app.secureTextFields["Password"]
    }
    
    func loginButton() -> XCUIElement {
        return app.buttons["Login"]
    }
    
    func findLabelWithText(_ text: String) -> XCUIElement {
        return app.staticTexts[text]
    }
    
}
