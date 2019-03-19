//
//  RoundedView.swift
//  Chatter
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable var cornerRadious: CGFloat = 15 {
        didSet {
            layer.cornerRadius = cornerRadious
        }
    }

    override func awakeFromNib() {
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = cornerRadious
    }
}
