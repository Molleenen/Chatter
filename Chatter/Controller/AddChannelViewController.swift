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
        guard let channelName = channelNameTextField.text, !channelName.isEmpty else {
            setPlaceholderColor(for: channelNameTextField)
            channelNameTextField.becomeFirstResponder()
            return
        }
        guard let channelDescription = channelDescriptionTextField.text else { return }
        
        SocketService
            .instance
            .addChannel(
                channelName: channelName,
                channelDescription: channelDescription)
            { success in
                guard success else { return }
                view.endEditing(true)
                dismiss(animated: true, completion: nil)
        }
    }

    private func setupView() {
        channelNameTextField.becomeFirstResponder()

        channelNameTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.channelName.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: PURPLE_PLACEHOLDER])
        channelDescriptionTextField.attributedPlaceholder = NSAttributedString(
            string: Placeholders.channelDescription.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: PURPLE_PLACEHOLDER])
    }

    private func setupDelegate() {
        channelNameTextField.delegate = self
        channelDescriptionTextField.delegate = self
    }

    private func setupBehaviour() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AddChannelViewController.handleTap)))
    }

    private func setPlaceholderColor(for textField: UITextField) {
        if textField == channelNameTextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: Placeholders.channelNameRequired.rawValue,
                attributes: [NSAttributedString.Key.foregroundColor: RED_PLACEHOLDER])
        }
    }

    @objc func handleTap() {
        view.endEditing(true)
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
