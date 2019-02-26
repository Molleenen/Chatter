//
//  Message.swift
//  Chatter
//

import Foundation

struct Message {
    public private(set) var id: String!
    public private(set) var messageBody: String!
    public private(set) var timeStamp: String!
    public private(set) var channelId: String!
    public private(set) var userName: String!
    public private(set) var userAvatar: String!
    public private(set) var userAvatarColor: String!
}
