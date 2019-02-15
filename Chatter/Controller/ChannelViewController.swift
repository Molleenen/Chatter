//
//  ChannelViewController.swift
//  Chatter
//
//  Created by Robert Abramczyk on 15/02/2019.
//  Copyright © 2019 Sebastian Wojciechowski. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width * 0.75
    }
    
}
