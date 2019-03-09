//
//  ChatViewController.swift
//  Chatter
//

import UIKit

class ChatViewController: UIViewController {
    
    private enum Keys: String {
        case userStoppedTyping = "stopType"
        case userStartedTyping = "startType"
    }

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messagePlaceholder: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUsersLabel: UILabel!
    
    private var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSockets()
        setupDelegate()
        setupTableView()
        setupBehaviour()
        setupNotifications()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.channelSelected?.name ?? ""
        channelNameLabel.text = "#\(channelName)"
        messagePlaceholder.isHidden = false
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { success in
            guard success else { return }
            if MessageService.instance.channels.count > 0 {
                MessageService.instance.channelSelected = MessageService.instance.channels[0]
                self.updateWithChannel()
            } else {
                self.channelNameLabel.text = "No channels added yet!"
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.channelSelected?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { [weak self] success in
            guard success else {
                print("Error getting messages for channel with id: \(channelId)")
                return
            }
            self?.messageTableView.reloadData()

            guard !MessageService.instance.messages.isEmpty else { return }
            let indexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
            self?.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @IBAction func messageEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.channelSelected?.id else { return }
        if messageTextView.text.isEmpty {
            isTyping = false
            sendButton.isHidden = true
            SocketService.instance.socket.emit(
                Keys.userStoppedTyping.rawValue,
                UserDataService.instance.name,
                channelId)
        } else {
            if isTyping == false {
                SocketService.instance.socket.emit(
                    Keys.userStartedTyping.rawValue,
                    UserDataService.instance.name,
                    channelId)
                sendButton.isHidden = false
            }
            isTyping = true
        }
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        guard
            AuthenticationService.instance.isLoggedIn,
            let channelId = MessageService.instance.channelSelected?.id,
            let message = messageTextView.text
        else {
            return
        }
        SocketService.instance.addMessage(
            messageBody: message,
            userId: UserDataService.instance.id,
            channelId: channelId
        ) { success in
            guard success else { return }
            self.messageTextView.text = ""
            self.sendButton.isHidden = true
            self.messagePlaceholder.isHidden = false
            SocketService.instance.socket.emit(Keys.userStoppedTyping.rawValue, UserDataService.instance.name, channelId)
        }
    }
    
    private func setupView() {
        if !AuthenticationService.instance.isLoggedIn {
            channelNameLabel.text = "Please log in"
            messagePlaceholder.isHidden = true
        }
        sendButton.isHidden = true
        menuButton.addTarget(
            self.revealViewController(),
            action: #selector(SWRevealViewController.revealToggle(_:)),
            for: .touchUpInside)

        messageTextView
            .bottomAnchor
            .constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8)
            .isActive = true

        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidChange(_ notification: Notification) {
        guard !MessageService.instance.messages.isEmpty else { return }
        let indexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
        messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    @objc func userDataDidChange() {
        if AuthenticationService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            messagePlaceholder.isHidden = true
            channelNameLabel.text = "Please Log In"
            messageTableView.reloadData()
        }
    }
    @objc func channelSelected() {
        updateWithChannel()
    }
    
    private func setupTableView() {
        messageTableView.estimatedRowHeight = 80
        messageTableView.rowHeight = UITableView.automaticDimension
    }

    private func setupDelegate() {
        messageTextView.delegate = self
        messageTableView.delegate = self
        messageTableView.dataSource = self
        revealViewController()?.delegate = self
    }
    
    private func setupBehaviour() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(ChatViewController.handleTap)))
    }
    
    private func setupSockets() {
        SocketService.instance.getChatMessage { [weak self] newMessage in
            guard
                newMessage.channelId == MessageService.instance.channelSelected?.id,
                AuthenticationService.instance.isLoggedIn
            else {
                return
            }
            
            MessageService.instance.messages.append(newMessage)
            self?.messageTableView.reloadData()
            guard !MessageService.instance.messages.isEmpty else { return }
            let indexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
            self?.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

        }
        
        SocketService.instance.getTypingUsers { [weak self] typingUsers in
            guard let channelId = MessageService.instance.channelSelected?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names.isEmpty {
                        names = typingUser
                    } else {
                        names += ", \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0, AuthenticationService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self?.typingUsersLabel.text = "\(names) \(verb) typing a message"
            } else {
                self?.typingUsersLabel.text = ""
            }
        }
    }
    
    private func setupNotifications() {
        if AuthenticationService.instance.isLoggedIn {
            AuthenticationService.instance.findUserByEmail { success in
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatViewController.userDataDidChange),
            name: NOTIFICATION_USER_DATA_DID_CHANGE,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(ChatViewController.channelSelected),
            name: NOTIFICATION_CHANNEL_SELECTED,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatViewController.keyboardDidChange(_:)),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil)
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.messageCell.rawValue,
            for: indexPath) as? MessageCell
        else {
            return UITableViewCell()
        }
        
        let message = MessageService.instance.messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != nil, textView.text != "" {
            sendButton.isHidden = false
            messagePlaceholder.isHidden = true

        } else {
            sendButton.isHidden = true
            messagePlaceholder.isHidden = false
        }
    }
}

extension ChatViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
}
