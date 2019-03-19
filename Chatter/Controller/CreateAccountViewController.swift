//
//  CreateAccountViewController.swift
//  Chatter
//

import UIKit
import MessageUI

class CreateAccountViewController: UIViewController {

    private var avatarName = "profileDefault"
    private var avatarColor = "[0.5, 0.5, 0.5, 1]"
    private var avatarBackgroundColor: UIColor?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDelegate()
        setupBehaviour()
    }

    override func viewWillAppear(_ animated: Bool) {
        if !UserDataService.instance.avatarName.isEmpty {
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName

            if avatarName.contains("light") && avatarBackgroundColor == nil {
                userImage.backgroundColor = UIColor.lightGray
            } else if avatarName.contains("dark") && avatarBackgroundColor == nil {
                userImage.backgroundColor = UIColor.white
            }
        }
    }

    @objc func handleTap() {
        view.endEditing(true)
    }

    private func setupView() {
        spinner.isHidden = true

        usernameTextField.becomeFirstResponder()

        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.userName.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: PURPLE_PLACEHOLDER])

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.userEmail.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: PURPLE_PLACEHOLDER])

        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.userPassword.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: PURPLE_PLACEHOLDER])
    }

    private func setupDelegate() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupBehaviour() {
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(CreateAccountViewController.handleTap)))
    }

    private func setPlaceholderColor(for textField: UITextField) {
        if textField == usernameTextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: Placeholders.userNameRequired.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: RED_PLACEHOLDER])
        } else if textField == emailTextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: Placeholders.userEmailRequired.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: RED_PLACEHOLDER])
        } else if textField == passwordTextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: Placeholders.userPasswordRequired.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: RED_PLACEHOLDER])
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
        UserDataService.instance.logoutUser()
    }

    @IBAction func chooseAvatarButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }

    @IBAction func generateBackgroundColorButtonPressed(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255)) / 255
        let green = CGFloat(arc4random_uniform(255)) / 255
        let blue = CGFloat(arc4random_uniform(255)) / 255

        avatarBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        avatarColor = "[\(red), \(green), \(blue), 1]"

        UIView.animate(withDuration: 0.2) {
            self.userImage.backgroundColor = self.avatarBackgroundColor
        }
    }

    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let name = usernameTextField.text, !name.isEmpty else {
            setPlaceholderColor(for: usernameTextField)
            usernameTextField.becomeFirstResponder()
            return
        }
        guard let email = emailTextField.text, emailTextField.text != "" else {
            setPlaceholderColor(for: usernameTextField)
            emailTextField.becomeFirstResponder()
            return
        }
        guard let password = passwordTextField.text, passwordTextField.text != "" else {
            setPlaceholderColor(for: usernameTextField)
            passwordTextField.becomeFirstResponder()
            return
        }

        spinner.isHidden = false
        spinner.startAnimating()
        view.isUserInteractionEnabled = false

        AuthenticationService.instance.registerUser(
            email: email,
            password: password) { [weak self] success in
                guard success else {
                    self?.view.isUserInteractionEnabled = true
                    return
                }
                AuthenticationService.instance.loginUser(
                    email: email,
                    password: password) { success in
                        guard success else {
                            self?.view.isUserInteractionEnabled = true
                            return
                        }
                        guard
                            let avatarName = self?.avatarName,
                            let avatarColor = self?.avatarColor
                        else {
                            self?.view.isUserInteractionEnabled = true
                            return
                        }
                        AuthenticationService.instance.createUser(
                            name: name,
                            email: email,
                            avatarName: avatarName,
                            avatarColor: avatarColor) { success in
                                self?.view.isUserInteractionEnabled = true
                                guard success else { return }
                                self?.spinner.isHidden = true
                                self?.spinner.stopAnimating()
                                NotificationCenter.default.post(
                                    name: NOTIFICATION_USER_DATA_DID_CHANGE,
                                    object: nil)
                                self?.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                        }
                }
        }
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isEditing {
            emailTextField.becomeFirstResponder()
            return false
        } else if emailTextField.isEditing {
            passwordTextField.becomeFirstResponder()
            return false
        } else {
            passwordTextField.resignFirstResponder()
            return true
        }
    }
}
