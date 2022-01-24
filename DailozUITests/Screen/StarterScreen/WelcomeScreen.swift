//
//  WelcomeScreen.swift
//  DailozUITests
//
//  Created by MAKOVEY Vladislav on 24.01.2022.
//

import XCTest

struct WelcomeScreen {
    
    let app: XCUIApplication!
    
    func loginButton() -> XCUIElement {
        return app.buttons["Login"]
    }
    
    func signUpButton() -> XCUIElement {
        return app.buttons["Sign Up"]
    }
}
