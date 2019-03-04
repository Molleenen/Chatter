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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUsersLabel: UILabel!
    
    private var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupBehaviour()
        setupSockets()
        setupNotifications()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.channelSelected?.name ?? ""
        channelNameLabel.text = "#\(channelName)"
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
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { success in
            guard success else {
                print("Error getting messages for channel with id: \(channelId)")
                return
            }
            self.messageTableView.reloadData()
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
            SocketService.instance.socket.emit(Keys.userStoppedTyping.rawValue, UserDataService.instance.name, channelId)
        }
    }
    
    private func setupView() {
        sendButton.isHidden = true
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.view.frame.origin.y += deltaY
            
        },completion: {(true) in
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func userDataDidChange() {
        if AuthenticationService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLabel.text = "Please Log In"
            messageTableView.reloadData()
        }
    }
    @objc func channelSelected() {
        updateWithChannel()
    }
    
    private func setupTableView() {
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.estimatedRowHeight = 80
        messageTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupBehaviour() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap)))
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
            
            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1 , section: 0)
            self?.messageTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
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
            selector: #selector(ChatViewController.keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
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
