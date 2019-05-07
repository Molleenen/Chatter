//
//  AvatarPickerViewModel.swift
//  Chatter
//

import Foundation

public class AvatarPickerViewModel {

    typealias AvatarPickerUpdateHandler = () -> Void
    typealias AvatarPickerDismissHandler = () -> Void

    var updateHandler: AvatarPickerUpdateHandler?
    var dismissHandler: AvatarPickerDismissHandler?

    var avatarType: AvatarType {
        didSet {
           updateHandler?()
        }
    }

    init() {
        self.avatarType = .dark
    }

    func getNumberOfItems() -> Int {
        return 28
    }

    func userSelectedAvatar(avatarName: String) {
        UserDataService.instance.setAvatarName(avatarName: avatarName)
        dismissHandler?()
    }
}
