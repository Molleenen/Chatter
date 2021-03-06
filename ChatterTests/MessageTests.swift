//
//  MessageTest.swift
//  ChatterTests
//

import XCTest
import SwiftyJSON
@testable import Chatter

class MessageTests: XCTestCase {

    var messageService: MessageService!

    var message: Message!
    var expectedMessage: Message!
    var expectedMessagesArray: [Message]!

    var correctJsonString: String!
    var corruptedJsonString: String!
    var emptyJsonString: String!
    
    var correctJsonArrayString: String!
    var corruptedJsonArrayString: String!
    var emptyJsonArrayString: String!

    override func setUp() {
        messageService = MessageService()

        message = Message(
            identifier: "messageId",
            messageBody: "messageBody",
            timeStamp: "timeStamp",
            channelId: "channelId",
            userName: "userName",
            userAvatar: "userAvatar",
            userAvatarColor: "userAvatarColor")

        expectedMessage = Message(
            identifier: "identifier",
            messageBody: "messageBody",
            timeStamp: "timeStamp",
            channelId: "channelId",
            userName: "userName",
            userAvatar: "userAvatar",
            userAvatarColor: "userAvatarColor")

        expectedMessagesArray = [expectedMessage]

        setupStrings()
    }

    private func setupStrings() {
        correctJsonString = """
        {
            "_id": "identifier",
            "messageBody": "messageBody",
            "timeStamp": "timeStamp",
            "channelId": "channelId",
            "userName": "userName",
            "userAvatar": "userAvatar",
            "userAvatarColor": "userAvatarColor"
        }
        """

        corruptedJsonString = """
        {
            "_id": "identifier",
            "messageBody": "messageBody",
            "timeStamp": "timeStamp",
            "channelId": "channelId"
        }
        """

        emptyJsonString = "{ }"

        correctJsonArrayString = """
        [ {
            "_id": "identifier",
            "messageBody": "messageBody",
            "timeStamp": "timeStamp",
            "channelId": "channelId",
            "userName": "userName",
            "userAvatar": "userAvatar",
            "userAvatarColor": "userAvatarColor"
        } ]
        """

        corruptedJsonArrayString = """
        [ {
            "_id": "identifier",
            "messageBody": "messageBody",
            "timeStamp": "timeStamp",
            "channelId": "channelId"
        } ]
        """

        emptyJsonArrayString = "[ ]"
    }

    func testMessageStruct() {
        XCTAssertNotNil(message, "Message is nil")
    }

    func testCreateMessageFromCorrectJson() {
        let json = JSON(parseJSON: correctJsonString)
        let response = messageService.createMessageFrom(jsonItem: json)
        XCTAssertEqual(response, expectedMessage)
    }

    func testCreateMessageFromCorruptedJson() {
        let json = JSON(parseJSON: corruptedJsonString)
        let response = messageService.createMessageFrom(jsonItem: json)
        XCTAssertNil(response)
    }

    func testCreateMessageFromEmptyJson() {
        let json = JSON(parseJSON: emptyJsonString)
        let response = messageService.createMessageFrom(jsonItem: json)
        XCTAssertNil(response)
    }

    func testCreateMessagesFromCorrectJsonArray() {
        guard let jsonArray = JSON(parseJSON: correctJsonArrayString).array else {
            XCTFail("Error getting jsonArray from JSON in messages from correct JSON array")
            return
        }
        let responseArray = messageService.createMessagesFrom(jsonArray: jsonArray)
        XCTAssertEqual(responseArray, expectedMessagesArray)
    }

    func testCreateMessagesFromCorruptedJsonArray() {
        guard let jsonArray = JSON(parseJSON: corruptedJsonArrayString).array else {
            XCTFail("Error getting jsonArray from JSON in messages from corrupted JSON array")
            return
        }
        let response = messageService.createMessagesFrom(jsonArray: jsonArray)
        XCTAssert(response.count == 0)
    }

    func testCreateMessagesFromEmptyJsonArray() {
        guard let jsonArray = JSON(parseJSON: emptyJsonArrayString).array else {
            XCTFail("Error getting jsonArray from JSON in channels from empty JSON array")
            return
        }
        let response = messageService.createMessagesFrom(jsonArray: jsonArray)
        XCTAssert(response.count == jsonArray.count)
    }
}
