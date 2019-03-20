//
//  ChannelViewController.swift
//  Chatter
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var addChannelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width * 0.75
        setupTableView()
        setupUserInfo()
        setupSockets()
        setupNotifications()
    }

    @objc func userDataDidChange() {
        setupUserInfo()
    }

    @objc func channelsLoaded() {
        channelTableView.reloadData()
        if MessageService.instance.channels.first != nil {
            let indexPath = IndexPath(row: 0, section: 0)
            channelTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

    }

    private func setupUserInfo() {
        if AuthenticationService.instance.isLoggedIn {
            addChannelButton.isHidden = false
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor =
                UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            if MessageService.instance.channels.first != nil {
                let indexPath = IndexPath(row: 0, section: 0)
                channelTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        } else {
            addChannelButton.isHidden = true
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

            let index = MessageService.instance.channels.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            let channel = MessageService.instance.channels[index]
            MessageService.instance.channelSelected = channel

            self.channelTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            NotificationCenter.default.post(name: notificationChannelSelected, object: nil)
            self.revealViewController()?.revealToggle(animated: true)
        }

        SocketService.instance.getChatMessage { newMessage in
            guard
                newMessage.channelId != MessageService.instance.channelSelected?.identifier,
                AuthenticationService.instance.isLoggedIn
                else {
                    return
            }

            MessageService.instance.unreadChannels.append(newMessage.channelId)
            self.channelTableView.reloadData()
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChannelViewController.userDataDidChange),
            name: notificationUserDataDidChange,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChannelViewController.channelsLoaded),
            name: notificationChannelsLoaded,
            object: nil)
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
            performSegue(withIdentifier: Segues.toLogin.rawValue, sender: nil)
        }
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
}

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: Cell.channelCell.rawValue,
                    for: indexPath) as? ChannelCell
        else {
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
            MessageService.instance.unreadChannels =
                MessageService.instance.unreadChannels.filter { $0 != channel.identifier}
        }

        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)

        NotificationCenter.default.post(name: notificationChannelSelected, object: nil)

        revealViewController()?.revealToggle(animated: true)
    }
}
