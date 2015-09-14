//
//  PreloaderVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 01/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import Firebase
//import SWRevealViewController

class PreloaderVC: UIViewController {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(animated: Bool) {
        
        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
        if ref.authData != nil {
            print("user logged in")
            print(ref.authData)
            if (self.userDefaults.stringForKey("company") == "" || self.userDefaults.stringForKey("description") == "" || self.userDefaults.stringForKey("picture") == "" || self.userDefaults.stringForKey("title") == "" || (self.userDefaults.stringForKey("phoneNo") == "" || self.userDefaults.stringForKey("mobilNo") == "")){
                userDefaults.setBool(true, forKey: "MustEditProfile")
            }
            
            performSegueWithIdentifier("loggedIn", sender: self)
        } else {
            print("user logged out")
            performSegueWithIdentifier("loggedOut", sender: self)
        }
    }
}
