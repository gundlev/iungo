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

    
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(animated: Bool) {
        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com")
        if ref.authData != nil {
            print("user logged in")
            print(ref.authData)
            performSegueWithIdentifier("loggedIn", sender: self)
        } else {
            print("user logged out")
            performSegueWithIdentifier("loggedOut", sender: self)
        }
    }
}
