//
//  MessageCell.swift
//  Chatter
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(message: Message) {
        messageBodyLabel.text = message.messageBody
        userNameLabel.text = message.userName
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor =
            UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        timeStampLabel.text = formatDate(stringDate: message.timeStamp)
    }

    private func formatDate(stringDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "E, d MMM yyyy HH:mm"

        if let date = dateFormatterGet.date(from: stringDate) {
            return dateFormatterPrint.string(from: date)
        } else {
            return stringDate
        }
    }
}
