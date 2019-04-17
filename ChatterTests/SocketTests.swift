//
//  SocketTests.swift
//  ChatterTests
//

import XCTest
@testable import Chatter

class SocketTests: XCTestCase {

    var socketService: SocketService!
    var expectedMessage: Message!
    var expectedChannel: Channel!
    var correctMessageData: [Any]!
    var corruptedMessageData: [Any]!
    var correctChannelData: [Any]!
    var corruptedChannelData: [Any]!
    var emptyData: [Any]!

    override func setUp() {
        socketService = SocketService()

        expectedMessage = Message(
            identifier: "identifier",
            messageBody: "messageBody",
            timeStamp: "timeStamp",
            channelId: "channelId",
            userName: "userName",
            userAvatar: "userAvatar",
            userAvatarColor: "userAvatarColor")

        expectedChannel = Channel(
            identifier: "identifier",
            name: "name",
            description: "description")

        correctMessageData = [
            "messageBody",
            "something",
            "channelId",
            "userName",
            "userAvatar",
            "userAvatarColor",
            "identifier",
            "timeStamp"
        ]

        corruptedMessageData = [
            "messageBody",
            "something",
            "channelId",
            "userName",
            "userAvatar",
            "userAvatarColor"
        ]

        correctChannelData = [
            "name",
            "description",
            "identifier"
        ]

        corruptedChannelData = [
            "name",
            "description"
        ]

        emptyData = []
    }

    func testCreateMessageFromCorrectData() {
        guard let result = socketService.createMessageFrom(data: correctMessageData) else {
            XCTFail("Error while unwrapping message from correct data")
            return
        }
        XCTAssertEqual(result, expectedMessage)
    }

    func testCreateMessageFromCorruptedData() {
        XCTAssertNil(socketService.createMessageFrom(data: corruptedMessageData))
    }

    func testCreateMessageFromEmptyData() {
        XCTAssertNil(socketService.createMessageFrom(data: emptyData))
    }

    func testCreateChannelFromCorrectData() {
        guard let result = socketService.createChannelFrom(data: correctChannelData) else {
            XCTFail("Error while unwrapping message from correct data")
            return
        }
        XCTAssertEqual(result, expectedChannel)
    }

    func testCreateChannelFromCorruptedData() {
        XCTAssertNil(socketService.createChannelFrom(data: corruptedChannelData))
    }

    func testCreateChannelFromEmptyData() {
        XCTAssertNil(socketService.createChannelFrom(data: emptyData))
    }

    func testAppendNewChannelFromCorrectData() {
        XCTAssert(socketService.appendNewChannelFrom(data: correctChannelData))
    }

    func testAppendNewChannelFromCorruptedData() {
        XCTAssertFalse(socketService.appendNewChannelFrom(data: corruptedChannelData))
    }

    func testAppendNewChannelFromEmptyData() {
        XCTAssertFalse(socketService.appendNewChannelFrom(data: emptyData))
    }
}
