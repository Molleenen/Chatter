//
//  ProfileViewController.swift
//  Chatter
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBehaviour()
    }

    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }

    private func setupView() {
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        profileImage.image = UIImage(named: UserDataService.instance.avatarName)
        profileImage.backgroundColor =
            UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    }

    private func setupBehaviour() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(ProfileViewController.handleTap)))
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
