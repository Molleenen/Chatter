//
//  RoundedView.swift
//  Chatter
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable var cornerRadious: CGFloat = 15 {
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
