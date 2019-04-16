//
//  LoginViewController.swift
//  Chatter
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDelegate()
        setupBehaviour()
    }

    @objc func handleTap() {
        view.endEditing(true)
    }

    private func setupView() {
        spinner.isHidden = true

        emailTextField.becomeFirstResponder()

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.userEmail.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.userPassword.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
    }

    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupBehaviour() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(LoginViewController.handleTap)))
    }

    private func setPlaceholderColor(for textField: UITextField) {
        if textField == emailTextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: Placeholders.userEmailRequired.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: redPlaceholder])
        } else if textField == passwordTextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: Placeholders.userPasswordRequired.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: redPlaceholder])
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Segues.toCreateAccount.rawValue, sender: nil)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {

        guard let email = emailTextField.text, !email.isEmpty else {
            setPlaceholderColor(for: emailTextField)
            emailTextField.becomeFirstResponder()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            setPlaceholderColor(for: passwordTextField)
            passwordTextField.becomeFirstResponder()
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
                NotificationCenter.default.post(name: .userDataDidChange, object: nil)
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
