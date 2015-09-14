//
//  MeetingsContainerVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 31/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class MeetingsContainerVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        // Set up menu
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
}
