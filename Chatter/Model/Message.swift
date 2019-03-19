//
//  Message.swift
//  Chatter
//

import Foundation

struct Message {
    private(set) var identifier: String
    private(set) var messageBody: String
    private(set) var timeStamp: String
    private(set) var channelId: String
    private(set) var userName: String
    private(set) var userAvatar: String
    private(set) var userAvatarColor: String
}
