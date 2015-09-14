//
//  MenuViewController.swift
//  MySlider
//
//  Created by Niklas Gundlev on 29/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let menu = ["Væg", "Netværksgrupper", "Mine Møder", "Profil", "Log ud"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(menu[indexPath.row])
        
        cell?.textLabel?.text = menu[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1.0
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        switch indexPath.row {
//        case 0:
//            
//            //performSegueWithIdentifier("first", sender: self)
//            
//        case 1:
//            performSegueWithIdentifier("second", sender: self)
//        default: print("what")
//        }
//    }
    
}
