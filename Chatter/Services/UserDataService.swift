//
//  UserDataService.swift
//  Chatter
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var red, green, blue, alpha: NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &red)
        scanner.scanUpToCharacters(from: comma, into: &green)
        scanner.scanUpToCharacters(from: comma, into: &blue)
        scanner.scanUpToCharacters(from: comma, into: &alpha)
        
        let defaultColor = UIColor.lightGray
        
        guard let redUnwrapped = red else { return defaultColor }
        guard let greenUnwrapped = green else { return defaultColor }
        guard let blueUnwrapped = blue else { return defaultColor }
        guard let alphaUnwrapped = alpha else { return defaultColor }
        
        let redFloat = CGFloat(redUnwrapped.doubleValue)
        let greenFloat = CGFloat(greenUnwrapped.doubleValue)
        let blueFloat = CGFloat(blueUnwrapped.doubleValue)
        let alphaFloat = CGFloat(alphaUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
        
        return newUIColor
        
    }
    
    func logoutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        name = ""
        email = ""
        AuthenticationService.instance.isLoggedIn = false
        AuthenticationService.instance.userEmail = ""
        AuthenticationService.instance.authenticationToken = ""
        MessageService.instance.clearChannels()
    }
}
