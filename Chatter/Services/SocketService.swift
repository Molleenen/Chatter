//
//  SocketService.swift
//  Chatter
//

import UIKit
import SocketIO

class SocketService: NSObject {

    private enum SocketKeys: String {
        case newChannel
        case channelCreated
        case newMessage
        case messageCreated
        case userTypingUpdate
    }

    static let instance = SocketService()

    private var manager = SocketManager(socketURL: URL(string: baseUrl)!)
    lazy var socket: SocketIOClient = manager.defaultSocket

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    func addChannel(
        channelName: String,
        channelDescription: String,
        completion: CompletionHandler
    ) {
        socket.emit(SocketKeys.newChannel.rawValue, channelName, channelDescription)
        completion(true)
    }

    func getChannel(completion: @escaping CompletionHandler) {
        socket.on(SocketKeys.channelCreated.rawValue) { dataArray, _ in
            guard dataArray.count >= 3 else {
                completion(false)
                return
            }
            guard
                let channelName = dataArray[0] as? String,
                let channelDescription = dataArray[1] as? String,
                let channelId = dataArray[2] as? String
            else {
                return
            }

            let newChannel = Channel(identifier: channelId, name: channelName, description: channelDescription)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }

    func addMessage(
        messageBody: String,
        userId: String,
        channelId: String,
        completion: CompletionHandler
    ) {

        let user = UserDataService.instance
        socket.emit(
            SocketKeys.newMessage.rawValue,
            messageBody,
            userId, channelId,
            user.name,
            user.avatarName,
            user.avatarColor)
        completion(true)
    }

    func getChatMessage(_ completionHandler: @escaping (Message) -> Void) {
        socket.on(SocketKeys.messageCreated.rawValue) { dataArray, _ in
            guard dataArray.count >= 6 else {
                return
            }
            guard
                let messageBody = dataArray[0] as? String,
                let channelId = dataArray[2] as? String,
                let userName = dataArray[3] as? String,
                let userAvatar = dataArray[4] as? String,
                let userAvatarColor = dataArray[5] as? String,
                let messageId = dataArray[6] as? String,
                let timeStamp = dataArray[7] as? String
            else {
                return
            }

            let newMessage = Message(
                identifier: messageId,
                messageBody: messageBody,
                timeStamp: timeStamp,
                channelId: channelId,
                userName: userName,
                userAvatar: userAvatar,
                userAvatarColor: userAvatarColor)

            completionHandler(newMessage)
        }
    }

    func getTypingUsers(_ completionHandler: @escaping ([String: String]) -> Void) {
        socket.on(SocketKeys.userTypingUpdate.rawValue) { dataArray, _ in
            guard !dataArray.isEmpty else {
                return
            }
            guard let typingUsers = dataArray[0] as? [String: String] else {
                return
            }
            completionHandler(typingUsers)
        }
    }
}
