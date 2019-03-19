//
//  AuthenticationService.swift
//  Chatter
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthenticationService {

    private enum Keys: String {
        case userId = "_id"
        case user = "user"
        case userName = "name"
        case userEmail = "email"
        case userPassword = "password"
        case userAvatarName = "avatarName"
        case userAvatarColor = "avatarColor"
        case authenticationToken = "token"
    }

    static let instance = AuthenticationService()

    let defaults = UserDefaults.standard

    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: UserDefaultsKeys.loggedIn.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.loggedIn.rawValue)
        }
    }

    var authenticationToken: String {
        get {
            guard let token = defaults.value(forKey: UserDefaultsKeys.tokenKey.rawValue) as? String else {
                fatalError("Authentication token for token key not found in user defaults")
            }
            return token
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.tokenKey.rawValue)
        }
    }

    var userEmail: String {
        get {
            guard let userEmail = defaults.value(forKey: UserDefaultsKeys.userEmail.rawValue) as? String else {
                fatalError("User email not found in user defaults")
            }
            return userEmail
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.userEmail.rawValue)
        }
    }

    func registerUser(
        email: String,
        password: String,
        completion: @escaping CompletionHandler
    ) {

        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            Keys.userEmail.rawValue: lowerCaseEmail,
            Keys.userPassword.rawValue: password
        ]

        Alamofire
            .request(
                urlRegister,
                method: .post,
                parameters: body,
                encoding: JSONEncoding.default,
                headers: header)
            .responseString { response in
                guard response.result.error == nil else {
                    debugPrint(response.result.error as Any)
                    completion(false)
                    return
                }
                completion(true)
            }
    }

    func loginUser(
        email: String,
        password: String,
        completion: @escaping CompletionHandler
    ) {

        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            Keys.userEmail.rawValue: lowerCaseEmail,
            Keys.userPassword.rawValue: password
        ]

        Alamofire
            .request(
                urlLogin,
                method: .post,
                parameters: body,
                encoding: JSONEncoding.default,
                headers: header)
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
                    let json = try JSON(data: data)
                    guard
                        let email = json[Keys.user.rawValue].string,
                        let token = json[Keys.authenticationToken.rawValue].string
                    else {
                        completion(false)
                        return
                    }
                    self?.userEmail = email
                    self?.authenticationToken = token
                } catch {
                    print("Error getting JSON from web response after logging user")
                    completion(false)
                    return
                }

                self?.isLoggedIn = true
                completion(true)
            }
    }

    func createUser(
        name: String,
        email: String,
        avatarName: String,
        avatarColor: String,
        completion: @escaping CompletionHandler
    ) {

        let lowerCaseEmail = email.lowercased()

        let body: [String: Any] = [
            Keys.userName.rawValue: name,
            Keys.userEmail.rawValue: lowerCaseEmail,
            Keys.userAvatarName.rawValue: avatarName,
            Keys.userAvatarColor.rawValue: avatarColor
        ]

        Alamofire
            .request(
                urlUserAdd,
                method: .post,
                parameters: body,
                encoding: JSONEncoding.default,
                headers: bearerHeader)
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
                self?.setUserInfo(data: data)
                completion(true)
        }
    }

    func findUserByEmail(completion: @escaping CompletionHandler) {

        Alamofire
            .request(
                "\(urlUserByEmail)\(userEmail)",
                method: .get, parameters: nil,
                encoding: JSONEncoding.default,
                headers: bearerHeader)
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
                self?.setUserInfo(data: data)
                completion(true)
        }
    }

    func setUserInfo(data: Data) {
        do {
            let json = try JSON(data: data)
            guard
                let userId = json[Keys.userId.rawValue].string,
                let avatarColor = json[Keys.userAvatarColor.rawValue].string,
                let avatarName = json[Keys.userAvatarName.rawValue].string,
                let email = json[Keys.userEmail.rawValue].string,
                let name = json[Keys.userName.rawValue].string
            else {
                 return
            }

            UserDataService
                .instance
                .setUserData(
                    userId: userId,
                    avatarColor:
                    avatarColor,
                    avatarName:
                    avatarName,
                    email: email,
                    name: name)
        } catch {
            print("Error getting JSON from web response after logging user")
        }
    }
}
