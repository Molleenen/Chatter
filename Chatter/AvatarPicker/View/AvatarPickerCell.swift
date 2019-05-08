//
//  AvatarPickerCell.swift
//  Chatter
//

import UIKit

class AvatarPickerCell: UICollectionViewCell {

    private var avatarImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable, message: "Use init(frame:) instead")
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
        let top = avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bottom = avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let leading = avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }

    func configureCell(index: Int, avatarType: AvatarType) {
        switch avatarType {
        case .dark:
            avatarImageView.image = UIImage(named: "dark\(index)")
            backgroundColor = .lightGray
        case .light:
            avatarImageView.image = UIImage(named: "light\(index)")
            backgroundColor = .gray
        }
    }

    private func setupView() {
        contentMode = .center
        clipsToBounds = true
        backgroundColor = .lightGray
        layer.cornerRadius = 10
    }
}
