//
//  CreateAccountViewController.swift
//  Chatter
//

import UIKit
import MessageUI

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var backgroundColor: UIColor?
    
    private var verificationCode: String = "0000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.becomeFirstResponder()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            
            if avatarName.contains("light") && backgroundColor == nil {
                userImage.backgroundColor = UIColor.lightGray
            } else if avatarName.contains("dark") && backgroundColor == nil {
                userImage.backgroundColor = UIColor.white
            }
        }
    }
    
    func setupView() {
        spinner.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.handleTap))
        view.addGestureRecognizer(tap)
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
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
        
        backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        avatarColor = "[\(red), \(green), \(blue), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.userImage.backgroundColor = self.backgroundColor
        }
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard
            let name = usernameTextField.text, usernameTextField.text != "",
            let email = emailTextField.text, emailTextField.text != "",
            let password = passwordTextField.text, passwordTextField.text != ""
        else {
            return
        }
        
        AuthenticationService.instance.registerUser(email: email, password: password) { success in
            guard success else { return }
            AuthenticationService.instance.loginUser(email: email, password: password, completion: { success in
                guard success else { return }
                AuthenticationService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { success in
                    guard success else { return }
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                    NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                })
            })
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
