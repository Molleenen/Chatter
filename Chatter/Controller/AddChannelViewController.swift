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
        setupView()
        setupDelegate()
        setupBehaviour()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelButtonPressed(_ sender: Any) {
        // TODO - channel name is required
        guard
            let channelName = channelNameTextField.text, !channelName.isEmpty,
            let channelDescription = channelDescriptionTextField.text
        else {
            return
        }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { success in
            guard success else { return }
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
    }

    private func setupView() {
        channelNameTextField.becomeFirstResponder()

        channelNameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        channelDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
    }

    @objc func handleTap() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    private func setupDelegate() {
        channelNameTextField.delegate = self
        channelDescriptionTextField.delegate = self
    }

    private func setupBehaviour() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AddChannelViewController.handleTap)))
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
