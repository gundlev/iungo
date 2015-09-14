//
//  NetworkGroupVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 11/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class NetworkGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var networkGroups: [NetworkGroup] = [NetworkGroup]()
    var active: [NetworkGroup] = [NetworkGroup]()
    var inactive: [NetworkGroup] = [NetworkGroup]()
    var selectedNG: NetworkGroup?
    var lastIndexSelected: NSIndexPath = NSIndexPath()
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: MyTableView!
    
    @IBAction func segmentChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.contentInset = UIEdgeInsetsZero
        // Setting up the navigation bar
        self.navigationItem.hidesBackButton = true
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
        
        // Set up menu
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        print(1)
        // Getting The network groups
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/users/" + userDefaults.stringForKey("uid")! + "/ngroup")
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            print(2)
            let jsonGroups = JSON(snapshot.value)
            print(jsonGroups)
            
            for (groupId, link) in jsonGroups {
                print(groupId)
                print(3)
                print(link.stringValue)
                let activeRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com" + link.stringValue)
                activeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    let status = snapshot.value as! String
                    
                    let networkGroupRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + groupId)
                    networkGroupRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        let jsonNetworkGroup = JSON(snapshot.value)
                        
                        let nImage: UIImage = UIImage(data: NSData(base64EncodedString: jsonNetworkGroup["image"].stringValue, options: NSDataBase64DecodingOptions(rawValue: 0))!)!
                        
                        //let temp = UIImage()
                        
                        let members = jsonNetworkGroup["members"]
                        var numberOfMembers = 0
                        for (userId, data) in members {
                            if data["status"].stringValue == "aktiv" {
                                numberOfMembers++
                            }
                        }
                        
                        
                        let networkGroup:NetworkGroup = NetworkGroup(nname: jsonNetworkGroup["name"].stringValue, nid: groupId, nsize: numberOfMembers, nmeetingFrequency: jsonNetworkGroup["meetingFrequency"].stringValue, nmeetDay: jsonNetworkGroup["meetDay"].stringValue, nmeetTime: jsonNetworkGroup["meetTime"].stringValue, nnetworkDescription: jsonNetworkGroup["description"].stringValue, nnetworkImage: nImage , nuserStatus: status, naddress: jsonNetworkGroup["address"].stringValue)
                        
                        if status == "aktiv" {
                            self.active.append(networkGroup)
                        } else {
                            self.inactive.append(networkGroup)
                        }
                        self.tableView.reloadData()
                    })
                    

                })
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("networkGroupCell") as! NetworkGroupCell
        
        if segment.selectedSegmentIndex == 0 {
            cell.userStatus.text = active[indexPath.row].userStatus
            cell.networkName.text = active[indexPath.row].name
            cell.members.text = String(active[indexPath.row].size) + " Medlemmer"
            cell.networkImage.image = active[indexPath.row].networkImage
        } else {
            cell.userStatus.text = inactive[indexPath.row].userStatus
            cell.networkName.text = inactive[indexPath.row].name
            cell.members.text = "Deltagere " + String(inactive[indexPath.row].size)
            cell.networkImage.image = inactive[indexPath.row].networkImage
        }
        
        
        return cell
    }
    
    @IBAction func backToNetworkGroups(sender: UIStoryboardSegue) {
        self.tableView.deselectRowAtIndexPath(lastIndexSelected, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected called")
        
        print(segment.selectedSegmentIndex)
        lastIndexSelected = indexPath
        
        if segment.selectedSegmentIndex == 0 {
            selectedNG = active[indexPath.row]
        } else {
            selectedNG = inactive[indexPath.row]
        }
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        print("highligted called")
        if segment.selectedSegmentIndex == 0 {
            selectedNG = active[indexPath.row]
        } else {
            selectedNG = inactive[indexPath.row]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return active.count
        } else {
            return inactive.count
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "listToNetworkGroup" {
            print("correct segue")
            let toVC = segue.destinationViewController as! NetworkGroupProfileVC
            toVC.networkGroup = selectedNG!
        } 
    }
    
}
