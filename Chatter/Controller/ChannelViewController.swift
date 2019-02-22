//
//  ChannelViewController.swift
//  Chatter
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInfo()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width * 0.75
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if AuthenticationService.instance.isLoggedIn {
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    @objc func userDataDidChange(_ notification: Notification) {
        setupUserInfo()
    }
    
    private func setupUserInfo() {
        if AuthenticationService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
        }
    }
}
