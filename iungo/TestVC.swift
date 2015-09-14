//
//  TestVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 07/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    @IBAction func exittingTheCurrentViewTest(sender: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as! MeetingViewController
        toViewController.fromVC = "TestVC"
    }
    
}
