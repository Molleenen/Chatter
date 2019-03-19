//
//  UserDataService.swift
//  Chatter
//

import Foundation

class UserDataService {

    static let instance = UserDataService()

    private(set) var userId = ""
    private(set) var avatarColor = ""
    private(set) var avatarName = ""
    private(set) var email = ""
    private(set) var name = ""

    func setUserData(
        userId: String,
        avatarColor: String,
        avatarName: String,
        email: String, name:
        String
    ) {

        self.userId = userId
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }

    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }

    func returnUIColor(components: String) -> UIColor {

        let colors = components
            .trimmingCharacters(in: ["[", "]"])
            .replacingOccurrences(of: ",", with: "")
            .split(separator: " ")
            .compactMap { NumberFormatter().number(from: String($0))?.floatValue }
            .map { CGFloat($0) }

        guard colors.count == 4 else {
            print("Error getting colors")
            return .lightGray
        }

        return UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
    }

    func logoutUser() {
        userId = ""
        avatarName = ""
        avatarColor = ""
        name = ""
        email = ""
        AuthenticationService.instance.isLoggedIn = false
        AuthenticationService.instance.userEmail = ""
        AuthenticationService.instance.authenticationToken = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
