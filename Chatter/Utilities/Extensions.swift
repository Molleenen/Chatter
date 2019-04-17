//
//  Extensions.swift
//  Chatter
//

import Foundation

extension Notification.Name {
    static let channelsLoaded: Notification.Name = {
        return Notification.Name(rawValue: "channelsLoaded")
    }()
    static let channelSelected: Notification.Name = {
        return Notification.Name(rawValue: "channelSelected")
    }()
    static let userDataDidChange: Notification.Name = {
        return Notification.Name(rawValue: "userDataDidChange")
    }()
}
