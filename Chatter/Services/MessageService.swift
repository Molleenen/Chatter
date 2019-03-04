//
//  MessageService.swift
//  Chatter
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    private enum Keys: String {
        case id = "_id"

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
    
    func findAllChannels(completion: @escaping CompletionHandler) {

        Alamofire
            .request(
                URL_GET_CHANNELS,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: BEARER_HEADER)
            .responseJSON { [weak self] response in

                guard response.result.error == nil else {
                    debugPrint(response.result.error as Any)
                    completion(false)
                    return
                }
                guard let data = response.data else {
                    completion(false)
                    return
                }
                do {
                    guard let json = try JSON(data: data).array else {
                        completion(false)
                        return
                    }

                    json.forEach { item in
                        guard
                            let id = item[Keys.id.rawValue].string,
                            let name = item[Keys.channelName.rawValue].string,
                            let description = item[Keys.channelDescription.rawValue].string
                        else {
                            completion(false)
                            return
                        }

                        let channel = Channel(id: id, name: name, description: description)
                        self?.channels.append(channel)
                    }

                    NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil)
                    completion(true)
                } catch {
                    print("Error getting JSON from data")
                    completion(false)
                }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        
        Alamofire
            .request(
                "\(URL_GET_MESSAGES)\(channelId)",
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: BEARER_HEADER)
            .responseJSON { response in

                guard response.result.error == nil else {
                    debugPrint(response.result.error as Any)
                    completion(false)
                    return
                }

                self.clearMessages()
                guard let data = response.data else {
                    completion(false)
                    return
                }
                do {
                    guard let json = try JSON(data: data).array else {
                        completion(false)
                        return
                    }

                    json.forEach { item in
                        guard
                            let id = item[Keys.id.rawValue].string,
                            let messageBody = item[Keys.messageBody.rawValue].string,
                            let timeStamp = item[Keys.messageTimeStamp.rawValue].string,
                            let channelId = item[Keys.channelId.rawValue].string,
                            let userName = item[Keys.userName.rawValue].string,
                            let userAvatar = item[Keys.userAvatar.rawValue].string,
                            let userAvatarColor = item[Keys.userAvatarColor.rawValue].string
                        else {
                            completion(false)
                            return
                        }

                        let message = Message(
                            id: id,
                            messageBody: messageBody,
                            timeStamp: timeStamp,
                            channelId: channelId,
                            userName: userName,
                            userAvatar: userAvatar,
                            userAvatarColor: userAvatarColor)

                        self.messages.append(message)
                    }

                    completion(true)
                } catch {
                    print("Error getting JSON from data")
                    completion(false)
                }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
}
