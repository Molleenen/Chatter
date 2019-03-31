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

    func addChannel(channelName: String, channelDescription: String, completion: CompletionHandler) {
        socket.emit(SocketKeys.newChannel.rawValue, channelName, channelDescription)
        completion(true)
    }

    func getChannel(completion: @escaping CompletionHandler) {
        socket.on(SocketKeys.channelCreated.rawValue) { [weak self] dataArray, _ in
            guard let result = self?.appendNewChannelFrom(data: dataArray) else {
                completion(false)
                return
            }
            completion(result)
        }
    }

    func addMessage(messageBody: String, userId: String, channelId: String, completion: CompletionHandler) {
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
        socket.on(SocketKeys.messageCreated.rawValue) { [weak self] dataArray, _ in

            guard let newMessage = self?.createMessageFrom(data: dataArray) else {
                return
            }
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

    func appendNewChannelFrom(data: [Any]) -> Bool {
        guard let newChannel = createChannelFrom(data: data) else {
            return false
        }
        MessageService.instance.channels.append(newChannel)
        return true
    }

    func createChannelFrom(data: [Any]) -> Channel? {
        guard
            data.count >= 3,
            let channelName = data[0] as? String,
            let channelDescription = data[1] as? String,
            let channelId = data[2] as? String
        else {
            return nil
        }

        return Channel(identifier: channelId, name: channelName, description: channelDescription)
    }

    func createMessageFrom(data: [Any]) -> Message? {
        guard
            data.count >= 8,
            let messageBody = data[0] as? String,
            let channelId = data[2] as? String,
            let userName = data[3] as? String,
            let userAvatar = data[4] as? String,
            let userAvatarColor = data[5] as? String,
            let messageId = data[6] as? String,
            let timeStamp = data[7] as? String
        else {
            return nil
        }

        return Message(
            identifier: messageId,
            messageBody: messageBody,
            timeStamp: timeStamp,
            channelId: channelId,
            userName: userName,
            userAvatar: userAvatar,
            userAvatarColor: userAvatarColor)
    }
}
