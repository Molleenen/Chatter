//
//  ChatterUITests.swift
//  ChatterUITests
//

import XCTest

class ChatterUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {

        continueAfterFailure = false

        app = XCUIApplication()

        app.launchArguments.append("--uitesting")

        XCUIApplication().launch()
    }

    func testNavigationWhenLoggedOut() {

        XCTAssert(app.isDisplayingChatView)
        let smackburgerButton = app.buttons["smackBurger"]
        smackburgerButton.tap()
        XCTAssert(app.isDisplayingChatView && app.isDisplayingChannelView)
        smackburgerButton.tap()
        XCTAssert(app.isDisplayingChatView)

        app.swipeRight()
        XCTAssert(app.isDisplayingChatView && app.isDisplayingChannelView)
        app.swipeLeft()
        XCTAssert(app.isDisplayingChatView)
        app.swipeRight()
        XCTAssert(app.isDisplayingChatView && app.isDisplayingChannelView)

        let loginButton = app.buttons["Login"]
        loginButton.tap()
        XCTAssert(app.isDisplayingLoginView)

        app.buttons["closeButton"].tap()
        XCTAssert(app.isDisplayingChatView && app.isDisplayingChannelView)

        loginButton.tap()
        XCTAssert(app.isDisplayingLoginView)

        let donTHaveAnAccountSignUpHereButton = app.buttons["Don't have an account? Sign up here"]
        donTHaveAnAccountSignUpHereButton.tap()
        XCTAssert(app.isDisplayingRegisterView)

        let closebuttonButton = app.buttons["closeButton"]
        closebuttonButton.tap()
        XCTAssert(app.isDisplayingChatView && app.isDisplayingChannelView)
        loginButton.tap()
        XCTAssert(app.isDisplayingLoginView)
        donTHaveAnAccountSignUpHereButton.tap()
        XCTAssert(app.isDisplayingRegisterView)
        app.buttons["Choose avatar"].tap()
        XCTAssert(app.isDisplayingAvatarView)

        app.buttons["smackBack"].tap()
        XCTAssert(app.isDisplayingRegisterView)
        closebuttonButton.tap()
        XCTAssert(app.isDisplayingChannelView && app.isDisplayingChatView)
        smackburgerButton.tap()
        XCTAssert(app.isDisplayingChatView && !app.isDisplayingChannelView)

    }
}

extension XCUIApplication {
    var isDisplayingChatView: Bool {
        return otherElements["chatView"].exists
    }
    var isDisplayingChannelView: Bool {
        return otherElements["channelView"].exists
    }
    var isDisplayingLoginView: Bool {
        return otherElements["loginView"].exists
    }
    var isDisplayingRegisterView: Bool {
        return otherElements["registerView"].exists
    }
    var isDisplayingAvatarView: Bool {
        return otherElements["avatarView"].exists
    }
}
