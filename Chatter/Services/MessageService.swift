//
//  MessageService.swift
//  Chatter
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {

    private enum Keys: String {
        case identifier = "_id"

        case channelId = "channelId"
        case channelName = "name"
        case channelDescription = "description"

        case messageBody = "messageBody"
        case messageTimeStamp = "timeStamp"

        case userName = "userName"
        case userAvatar = "userAvatar"
        case userAvatarColor = "userAvatarColor"
    }

    static let instance = MessageService()

    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var channelSelected: Channel?

    func clearMessages() {
        messages.removeAll()
    }

    func clearChannels() {
        channels.removeAll()
    }

    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire
            .request(
                "\(urlGetMessages)\(channelId)",
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: bearerHeader)
            .responseJSON { [weak self] response in

                guard let result = self?.processMessagesResponse(response: response) else {
                    completion(false)
                    return
                }
                completion(result)
        }
    }

    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire
            .request(
                urlGetChannels,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: bearerHeader)
            .responseJSON { [weak self] response in

                guard let result = self?.processChannelsResponse(response: response) else {
                    completion(false)
                    return
                }
                completion(result)
        }
    }

    private func processChannelsResponse(response: DataResponse<Any>) -> Bool {
        if let error = response.result.error {
            debugPrint("\(error.localizedDescription)")
            return false
        }
        guard let data = response.data else { return false }

        do {
            guard let jsonArray = try JSON(data: data).array else { return false }

            channels = createChannelsFrom(jsonArray: jsonArray)
            NotificationCenter.default.post(name: .channelsLoaded, object: nil)
            return true
        } catch {
            print("Error getting channels JSON from data")
            return false
        }
    }

    private func processMessagesResponse(response: DataResponse<Any>) -> Bool {
        if let error = response.result.error {
            debugPrint("\(error.localizedDescription)")
            return false
        }
        guard let data = response.data else { return false }

        do {
            guard let jsonArray = try JSON(data: data).array else { return false }

            messages = createMessagesFrom(jsonArray: jsonArray)
            return true
        } catch {
            print("Error getting JSON from data")
            return false
        }
    }

    internal func createChannelsFrom(jsonArray: [JSON]) -> [Channel] {
        return jsonArray.compactMap { createChannelFrom(jsonItem: $0) }
    }

    internal func createChannelFrom(jsonItem: JSON) -> Channel? {
        guard
            let channelId = jsonItem[Keys.identifier.rawValue].string,
            let name = jsonItem[Keys.channelName.rawValue].string,
            let description = jsonItem[Keys.channelDescription.rawValue].string
        else { return nil }

        let channel = Channel(identifier: channelId, name: name, description: description)
        return channel
    }

    internal func createMessagesFrom(jsonArray: [JSON]) -> [Message] {
        return jsonArray.compactMap { createMessageFrom(jsonItem: $0) }
    }

    internal func createMessageFrom(jsonItem: JSON) -> Message? {
        guard
            let messageId = jsonItem[Keys.identifier.rawValue].string,
            let messageBody = jsonItem[Keys.messageBody.rawValue].string,
            let timeStamp = jsonItem[Keys.messageTimeStamp.rawValue].string,
            let channelId = jsonItem[Keys.channelId.rawValue].string,
            let userName = jsonItem[Keys.userName.rawValue].string,
            let userAvatar = jsonItem[Keys.userAvatar.rawValue].string,
            let userAvatarColor = jsonItem[Keys.userAvatarColor.rawValue].string
        else { return nil }

        let message = Message(
            identifier: messageId,
            messageBody: messageBody,
            timeStamp: timeStamp,
            channelId: channelId,
            userName: userName,
            userAvatar: userAvatar,
            userAvatarColor: userAvatarColor)

        return message
    }
}
