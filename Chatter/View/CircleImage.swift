//
//  CircleImage.swift
//  Chatter
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
