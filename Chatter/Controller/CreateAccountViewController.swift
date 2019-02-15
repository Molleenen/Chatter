//
//  CreateAccountViewController.swift
//  Chatter
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func chooseAvatarButtonPressed(_ sender: Any) {
        
    }
    @IBAction func generateBackgroundColorButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, emailTextField.text != "" else
            { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else
            { return }
        
        AuthenticationService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthenticationService.instance.loginUser(email: email, password: password) { (success) in
                    print("User logged in with token: ", AuthenticationService.instance.authenticationToken)
                }
            }
        }
    }
    
}
