//
//  LoginViewController.swift
//  Chatter
//

import UIKit

class LoginViewController: UIViewController {
    
    private enum Keys: String {
        case email = "email"
        case password = "password"
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDelegate()
        setupBehaviour()
    }
    
    private func setupView() {
        spinner.isHidden = true
        
        emailTextField.becomeFirstResponder()
        
        // TODO - constants
        emailTextField.attributedPlaceholder = NSAttributedString(string: Keys.email.rawValue, attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: Keys.password.rawValue, attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupBehaviour() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap)))
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // TODO - dividie guards and check empty textfields and change background
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.backgroundColor = UIColor.red
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            emailTextField.backgroundColor = UIColor.red
            return
        }
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        view.endEditing(true)
        view.isUserInteractionEnabled = false

        AuthenticationService.instance.loginUser(email: email, password: password) { [weak self] success in
            guard success else {
                self?.view.isUserInteractionEnabled = true
                return
            }
            AuthenticationService.instance.findUserByEmail(completion: { success in
                self?.view.isUserInteractionEnabled = true
                guard success else { return }
                
                self?.spinner.isHidden = true
                self?.spinner.stopAnimating()
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isEditing {
            passwordTextField.becomeFirstResponder()
            return false
        } else {
            passwordTextField.resignFirstResponder()
            return true
        }
    }
}
