//
//  AvatarPickerViewModel.swift
//  Chatter
//

import Foundation

public class AvatarPickerViewModel {

    typealias AvatarPickerUpdateViewHandler = () -> Void
    typealias AvatarPickerDismissViewHandler = () -> Void

    var updateViewHandler: AvatarPickerUpdateViewHandler?
    var dismissViewHandler: AvatarPickerDismissViewHandler?

    var avatarType: AvatarType {
        didSet {
           updateViewHandler?()
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
        dismissViewHandler?()
    }
}
