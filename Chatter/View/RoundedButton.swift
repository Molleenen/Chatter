//
//  RoundedButton.swift
//  Chatter
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadious: CGFloat = 10 {
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
