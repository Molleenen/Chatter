//
//  AddChannelViewController.swift
//  Chatter
//

import UIKit

class AddChannelViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var channelNameTextField: UITextField!
    @IBOutlet weak var channelDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelNameTextField.delegate = self
        channelDescriptionTextField.delegate = self
        channelNameTextField.becomeFirstResponder()
        setupView()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelButtonPressed(_ sender: Any) {
        guard let channelName = channelNameTextField.text, channelNameTextField.text != "" else { return }
        guard let channelDescription = channelDescriptionTextField.text else { return }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeTap(_:)))
        backgroundView.addGestureRecognizer(closeTouch)
        
        channelNameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        channelDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddChannelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if channelNameTextField.isEditing {
            channelDescriptionTextField.becomeFirstResponder()
            return false
        } else {
            channelDescriptionTextField.resignFirstResponder()
            return true
        }
    }
}
