//
//  RefVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 16/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class RefVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        // Setting up the navigation bar
        self.navigationItem.hidesBackButton = true
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
        
        // Set up menu
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
