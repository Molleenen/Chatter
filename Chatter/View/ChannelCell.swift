//
//  ChannelCell.swift
//  Chatter
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }

    func configureCell(channel: Channel) {
        let name = channel.name
        channelName.text = "#\(name)"
        channelName.font = UIFont(name: helveticaRegular, size: 17)

        for identifier in MessageService.instance.unreadChannels {
            if identifier == channel.identifier {
                channelName.font = UIFont(name: helveticaBold, size: 22)
            }
        }
    }
}
