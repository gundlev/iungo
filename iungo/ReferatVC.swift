//
//  ReferatVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 16/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ReferatVC: UIViewController {

    var referat: String?
    
    @IBAction func bacButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("backFromReferat", sender: self)
    }
    
    @IBOutlet weak var referatText: UITextView!
    
    override func viewDidLoad() {
        
        self.navigationItem.hidesBackButton = true
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
        
        referatText.text = referat!
        self.referatText.scrollRangeToVisible(NSMakeRange(0, 0))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
