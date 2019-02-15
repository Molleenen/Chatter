//
//  RoundedButton.swift
//  Chatter
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadious: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadious
    }

}
