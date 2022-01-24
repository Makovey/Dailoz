//
//  DailozUITests.swift
//  DailozUITests
//
//  Created by MAKOVEY Vladislav on 24.01.2022.
//

import XCTest

class DailozUITests: XCTestCase {
    
    var app: XCUIApplication!
    var welcomeScreen: WelcomeScreen!
    var loginScreen: LoginScreen!
    var homeScreen: HomeScreen!
    var taskScreen: TaskScreen!
    var addTaskScreen: AddTaskScreen!
    var profileScreen: ProfileScreen!
    
    var user: TestUser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        welcomeScreen = WelcomeScreen(app: app)
        loginScreen = LoginScreen(app: app)
        homeScreen = HomeScreen(app: app)
        taskScreen = TaskScreen(app: app)
        addTaskScreen = AddTaskScreen(app: app)
        profileScreen = ProfileScreen(app: app)
        
        user = TestUser(email: "q1@mail.ru", password: "123456", username: "Vas1")
    }
    
    func testSmokeCommon() throws {
        loginToApp()
        
        taskScreen.tabBarItem().tap()
        XCTAssertTrue(taskScreen.tabBarItemSelected().exists)
        XCTAssertTrue(taskScreen.findLabelWithText("Day").exists)
        XCTAssertTrue(taskScreen.findLabelWithText("Tasks").exists)
        
        addTaskScreen.tabBarItem().tap()
        XCTAssertTrue(addTaskScreen.tabBarItem().isSelected)
        XCTAssertTrue(addTaskScreen.findLabelWithText("Add Task").exists)
        XCTAssertTrue(addTaskScreen.createButton().exists)
        
        profileScreen.tabBarItem().tap()
        XCTAssertTrue(profileScreen.tabBarItemSelected().exists)
        XCTAssertTrue(profileScreen.findLabelWithText(user.email).exists)
        profileScreen.logoutButton().tap()
        sleep(2)
        
        XCTAssertTrue(welcomeScreen.loginButton().exists)
    }
    
    private func loginToApp() {
        if !welcomeScreen.loginButton().exists {
            sleep(2)
            profileScreen.tabBarItem().tap()
            profileScreen.logoutButton().tap()
            sleep(2)
        }
        
        welcomeScreen.loginButton().tap()
        sleep(2)
        
        XCTAssertTrue(loginScreen.findLabelWithText("Login").exists)
        
        loginScreen.emailTextField().tap()
        loginScreen.emailTextField().typeText(user.email)
        loginScreen.passwordTextField().tap()
        loginScreen.passwordTextField().typeText(user.password)
        loginScreen.loginButton().tap()
        sleep(2)
        
        XCTAssertTrue(homeScreen.tabBarItemSelected().exists)
        XCTAssertTrue(homeScreen.findLabelWithText(user.username).exists)
    }
    
}


struct TestUser {
    let email: String
    let password: String
    let username: String
}
