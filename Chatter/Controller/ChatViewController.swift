//
//  ChatViewController.swift
//  Chatter
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AuthenticationService.instance.isLoggedIn {
            AuthenticationService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        menuButtonSetup()
    }
    
    private func menuButtonSetup() {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

}
