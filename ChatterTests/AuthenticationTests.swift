//
//  AuthenticationTests.swift
//  ChatterTests
//

import XCTest
import SwiftyJSON
@testable import Chatter

class AuthenticationTests: XCTestCase {

    var authenticationService: AuthenticationService!

    var emptyJson: String!
    var userDataCorrectJson: String!
    var userDataCorruptedJson: String!
    var authenticationCorrectJson: String!
    var authenticationCorruptedJson: String!

    var expectedMail: String!
    var expectedToken: String!

    override func setUp() {
        authenticationService = AuthenticationService()

        emptyJson = "{ }"

        userDataCorrectJson = """
        {
            "_id": "identifier",
            "avatarColor": "avatarColor",
            "avatarName": "avatarName",
            "email": "email",
            "name": "name"
        }
        """

        userDataCorruptedJson = """
        {
            "_id": "identifier",
            "avatarColor": "avatarColor",
            "avatarName": "avatarName",
            "email": "email"
        }
        """

        authenticationCorrectJson = """
        {
            "user": "mail",
            "token": "token"
        }
        """

        authenticationCorruptedJson = """
        {
            "user": "mail"
        }
        """

        expectedMail = "mail"
        expectedToken = "token"
    }

    override func tearDown() {
        authenticationService.userEmail = ""
        authenticationService.authenticationToken = ""
    }

    func testSetAuthenticationDataFromCorrectJson() {
        let json = JSON(parseJSON: authenticationCorrectJson)
        XCTAssert(authenticationService.setAuthenticationDataFrom(json: json))
        XCTAssert(authenticationService.userEmail == expectedMail)
        XCTAssert(authenticationService.authenticationToken == expectedToken)
    }

    func testSetAuthenticationDataFromCorruptedJson() {
        let json = JSON(parseJSON: authenticationCorruptedJson)
        XCTAssertFalse(authenticationService.setAuthenticationDataFrom(json: json))
        XCTAssertFalse(authenticationService.userEmail == expectedMail)
        XCTAssertFalse(authenticationService.authenticationToken == expectedToken)
    }

    func testSetAuthenticationDataFromEmptyJson() {
        let json = JSON(parseJSON: emptyJson)
        XCTAssertFalse(authenticationService.setAuthenticationDataFrom(json: json))
        XCTAssertFalse(authenticationService.userEmail == expectedMail)
        XCTAssertFalse(authenticationService.authenticationToken == expectedToken)
    }

    func testSetUserDataFromCorrectJson() {
        let json = JSON(parseJSON: userDataCorrectJson)
        XCTAssert(authenticationService.setUserDataFrom(json: json))
    }

    func testSetUserDataFromCorruptedJson() {
        let json = JSON(parseJSON: userDataCorruptedJson)
        XCTAssertFalse(authenticationService.setUserDataFrom(json: json))
    }

    func testSetUserDataFromEmptyJson() {
        let json = JSON(parseJSON: emptyJson)
        XCTAssertFalse(authenticationService.setUserDataFrom(json: json))
    }
}
