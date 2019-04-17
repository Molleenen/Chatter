//
//  Constants.swift
//  Chatter
//

import Foundation

typealias CompletionHandler = (Bool) -> Void

// URL Constants
let baseUrl = "https://fierce-oasis-16295.herokuapp.com/v1/"
let urlRegister = "\(baseUrl)account/register"
let urlLogin = "\(baseUrl)account/login"
let urlUserAdd = "\(baseUrl)user/add"
let urlUserByEmail = "\(baseUrl)user/byEmail/"
let urlGetChannels = "\(baseUrl)channel/"
let urlGetMessages = "\(baseUrl)message/byChannel/"

// Fonts
let helveticaRegular = "HelveticaNeue-Regular"
let helveticaBold = "HelveticaNeue-Bold"

// Colors
let purplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)
let redPlaceholder = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.5)

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

// Segues names
enum Segues: String {
    case toLogin
    case toCreateAccount
    case unwindToChannel
    case toAvatarPicker
}

// Cells identifiers
enum Cell: String {
    case messageCell
    case channelCell
    case avatarCell
}

// User Defaults Keys
enum UserDefaultsKeys: String {
    case tokenKey
    case loggedIn
    case userEmail
}


// Headers
let header = [
    "Content-Type": "application/json; charset=utf-8"
]
let bearerHeader = [
    "Authorization": "Bearer \(AuthenticationService.instance.authenticationToken)",
    "Content-Type": "application/json; charset=utf-8"
]
