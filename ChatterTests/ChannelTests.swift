//
//  MessageTest.swift
//  ChatterTests
//

import XCTest
import SwiftyJSON
@testable import Chatter

class ChannelTests: XCTestCase {

    var channel: Channel!
    var messageService: MessageService!
    var correctJsonString: String!
    var corruptedJsonString: String!
    var emptyJsonString: String!
    var correctJsonArrayString: String!
    var corruptedJsonArrayString: String!
    var emptyJsonArrayString: String!
    var expectedChannel: Channel!
    var expectedChannelsArray: [Channel]!

    override func setUp() {
        messageService = MessageService()
        channel = Channel(identifier: "channelId", name: "channelName", description: "channelDesription")
        correctJsonString = "{ \"_id\": \"identifier\", \"name\": \"channel\", \"description\": \"description\" }"
        corruptedJsonString = "{ \"_id\": \"identifier\", \"name\": \"channel\" }"
        emptyJsonString = "{ }"
        correctJsonArrayString = "[ { \"_id\": \"identifier\", \"name\": \"channel\", \"description\": \"description\" } ]"
        corruptedJsonArrayString = "[ { \"_id\": \"identifier\", \"name\": \"channel\" } ]"
        emptyJsonArrayString = "[ ]"
        expectedChannel = Channel(identifier: "identifier", name: "channel", description: "description")
        expectedChannelsArray = [expectedChannel]
    }

    func testChannelStruct() {
        XCTAssertNotNil(channel, "Channel is nil")
    }

    func testCreateChannelFromCorrectJson() {
        let json = JSON(parseJSON: correctJsonString)
        let response = messageService.createChannelFrom(jsonItem: json)
        XCTAssertEqual(response, expectedChannel)
    }

    func testCreateChannelFromCorruptedJson() {
        let json = JSON(parseJSON: corruptedJsonString)
        let response = messageService.createChannelFrom(jsonItem: json)
        XCTAssertNil(response)
    }

    func testCreateChannelFromEmptyJson() {
        let json = JSON(parseJSON: emptyJsonString)
        let response = messageService.createChannelFrom(jsonItem: json)
        XCTAssertNil(response)
    }

    func testCreateChannelsFromCorrectJsonArray() {
        guard let jsonArray = JSON(parseJSON: correctJsonArrayString).array else {
            print("Error getting jsonArray from JSON in channels from correct JSON array")
            return
        }
        let responseArray = messageService.createChannelsFrom(jsonArray: jsonArray)
        XCTAssertEqual(responseArray, expectedChannelsArray)
    }

    func testCreateChannelsFromCorruptedJsonArray() {
        guard let jsonArray = JSON(parseJSON: corruptedJsonArrayString).array else {
            print("Error getting jsonArray from JSON in channels from corrupted JSON array")
            return
        }

        let response = messageService.createChannelsFrom(jsonArray: jsonArray)
        XCTAssert(response.count == 0)
    }

    func testCreateChannelsFromEmptyJsonArray() {
        guard let jsonArray = JSON(parseJSON: emptyJsonArrayString).array else {
            print("Error getting jsonArray from JSON in channels from empty JSON array")
            return
        }

        let response = messageService.createChannelsFrom(jsonArray: jsonArray)
        XCTAssert(response.count == jsonArray.count)
    }
}
