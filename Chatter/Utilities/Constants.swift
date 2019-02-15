//
//  Constants.swift
//  Chatter
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "https://fierce-oasis-16295.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"

// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNEL = "unwindToChannel"

// User Defaults
let TOKEN = "tokenKey"
let LOGGED_IN = "loggedIn"
let USER_EMAIL = "userEmail"
