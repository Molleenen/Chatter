//
//  AvatarPickerCell.swift
//  Chatter
//

import UIKit

class AvatarPickerCell: UICollectionViewCell {

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        constructHierarchy()
        activateConstraints()
    }

    private func constructHierarchy() {
        addSubview(avatarImageView)
    }

    private func activateConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let top = avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        let bottom = avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        let leading = avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        let trailing = avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }

    func configureCell(index: Int, type: AvatarType) {
        if type == AvatarType.dark {
            avatarImageView.image = UIImage(named: "dark\(index)")
            layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            avatarImageView.image = UIImage(named: "light\(index)")
            layer.backgroundColor = UIColor.gray.cgColor
        }
    }

    private func setupView() {
        contentMode = .center
        clipsToBounds = true
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
    }
}
