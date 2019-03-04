//
//  ChannelViewController.swift
//  Chatter
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width * 0.75
        setupUserInfo()
        setupTableView()
        setupSockets()
        setupNotifications()
    }
    
    @IBAction func addChannelButtonPressed(_ sender: Any) {
        guard AuthenticationService.instance.isLoggedIn else { return }
        
        let addChannel = AddChannelViewController()
        addChannel.modalPresentationStyle = .custom
        present(addChannel, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if AuthenticationService.instance.isLoggedIn {
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    @objc func userDataDidChange() {
        setupUserInfo()
    }
    @objc func channelsLoaded() {
        channelTableView.reloadData()
    }
    
    private func setupUserInfo() {
        if AuthenticationService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            channelTableView.reloadData()
        }
    }
    
    private func setupTableView() {
        channelTableView.delegate = self
        channelTableView.dataSource = self
    }
    
    private func setupSockets() {
        SocketService.instance.getChannel { success in
            guard success else { return }
            
            self.channelTableView.reloadData()
        }
        
        SocketService.instance.getChatMessage { newMessage in
            guard
                newMessage.channelId != MessageService.instance.channelSelected?.id,
                AuthenticationService.instance.isLoggedIn
            else {
                return
            }
            
            MessageService.instance.unreadChannels.append(newMessage.channelId)
            self.channelTableView.reloadData()
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.channelsLoaded), name: NOTIFICATION_CHANNELS_LOADED, object: nil)
    }
}

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.channelCell.rawValue, for: indexPath) as? ChannelCell else {
            return UITableViewCell()
        }
        
        let channel = MessageService.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.channelSelected = channel
        
        if !MessageService.instance.unreadChannels.isEmpty {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{ $0 != channel.id }
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIFICATION_CHANNEL_SELECTED, object: nil)
        
        revealViewController()?.revealToggle(animated: true)
    }
}
