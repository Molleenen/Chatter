//
//  Constants.swift
//  Chatter
//

import Foundation

typealias CompletionHandler = (Bool) -> (Void)

// URL Constants
let BASE_URL = "https://fierce-oasis-16295.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"

// Fonts
let HELVETICA_REGULAR = "HelveticaNeue-Regular"
let HELVETICA_BOLD = "HelveticaNeue-Bold"

// Colors
let PURPLE_PLACEHOLDER = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)
let RED_PLACEHOLDER = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.5)

// Text fields Placeholders
enum Placeholders: String {
    case channelName = "name"
    case channelDescription = "description"
    case channelNameRequired = "name is required"

    case userName = "username"
    case userEmail = "email"
    case userPassword = "password"
    case userNameRequired = "username is required"
    case userEmailRequired = "email is required"
    case userPasswordRequired = "password is required"
}

// Notification Constants
let NOTIFICATION_USER_DATA_DID_CHANGE = Notification.Name("notificationUserDataChanged")
let NOTIFICATION_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIFICATION_CHANNEL_SELECTED = Notification.Name("channelSelected")

// Segues names
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNEL = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// Cells identifiers
enum Cell: String {
    case messageCell = "messageCell"
    case channelCell = "channelCell"
    case avatarCell = "avatarCell"
}

// User Defaults Keys
let TOKEN = "tokenKey"
let LOGGED_IN = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthenticationService.instance.authenticationToken)",
    "Content-Type": "application/json; charset=utf-8"
]
