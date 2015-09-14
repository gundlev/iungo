//
//  ViewController.swift
//  iungo
//
//  Created by Niklas Gundlev on 18/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //let userid = "003"
    var meetings: [Meeting] = [Meeting]()
    var groups: [String] = [""]
    var currentMeetings: [Meeting] = [Meeting]()
    let transitionManager = TransitionManager()
    var lastIndexSelected: NSIndexPath = NSIndexPath()
    
    @IBAction func changedSegment(sender: UISegmentedControl) {
        self.setCurrent()
        self.tableview.reloadData()
    }
    
//    @IBAction func menuClicked(sender: UIBarButtonItem) {
//        print("menu button clicked")
//        // set up a button with revealViewController and click it
//        let revealButton: UIButton = UIButton()
//        revealButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
//        revealButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
//    }
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func exittingTheCurrentView(sender: UIStoryboardSegue) {
        self.tableview.deselectRowAtIndexPath(lastIndexSelected, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear has been called")
    }
    
    override func viewDidLoad() {
        
        // Get permission for notifications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
        super.viewDidLoad()
        print("viewDidLoad has been called")
        //self.navigationController?.navigationBar.frame.offsetInPlace(dx: 0, dy: -20)
        self.navigationItem.hidesBackButton = true
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
        
        
        
        
        // Set up menu
        menu.target = self.revealViewController()
        menu.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        groups.removeAll()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        // Find array of groups from the specefic user
        let url = "https://brilliant-torch-4963.firebaseio.com/users/" + userDefaults.stringForKey("uid")! + "/ngroup"
        let groupRef = Firebase(url:url)
        
        groupRef.observeEventType(.Value, withBlock: { snapshot in
            
            let jsonGroups = JSON(snapshot.value)
            
            // Go through the list of groups
            for (groupName, ngroup) in jsonGroups {
                
                // Follow the path to see if the user is an active member
                let groupUrl = "https://brilliant-torch-4963.firebaseio.com" + ngroup.description
                print(groupUrl)
                let ngroupRef = Firebase(url:groupUrl)
                // TODO: make this a single download event
                ngroupRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
                    
                    print("In first step")
                    // Check if active
                    if snapshot.value as! String == "aktiv" {
                        // The user us active, so get the meetings from that group
                        let specificUrl = "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + groupName + "/meetings"
                        print(specificUrl)
                        
                        let ref = Firebase(url: specificUrl)
                        // TODO: make this a single download event
                        ref.queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
                            
                            print("In second step")
                            self.meetings.removeAll()
                            
                            let json = JSON(snapshot.value)
                            print(json)
                            
                            // Create meeting objects for all meetings, and add them to the meetings array.
                            for (key, subJson) in json {
                                
                                var numberOfParticipating = 0
                                for (_, status) in subJson["participants"] {
                                    if status["status"].intValue == 1 {
                                        numberOfParticipating++
                                    }
                                }
                                let groupNameRef = Firebase(url: ("https://brilliant-torch-4963.firebaseio.com/networkgroups/" + groupName))
                                
                                groupNameRef.observeSingleEventOfType(.Value, withBlock: { groupNameData in
                                
                                    let nameJson = JSON(groupNameData.value)
                                    
                                    let meeting = Meeting(oid: key, ogroupId: groupName, otitle: subJson["title"].stringValue, otext: subJson["text"].stringValue, odate: subJson["date"].stringValue, otime: subJson["time"].stringValue, oaddress: subJson["address"].stringValue, oname: nameJson["name"].stringValue, onumber: numberOfParticipating)
                                
                                    for (subkey, subsubJson) in subJson["participants"] {
                                        meeting.setParticipant(subkey, status: subsubJson["status"].intValue)
                                        if subkey == userDefaults.stringForKey("uid")! {
                                        meeting.status = subsubJson["status"].intValue
                                        }
                                    }
                                
                                    self.meetings.append(meeting)
                                    self.setCurrent()
                                    self.tableview.reloadData()
                                })
                                
                                

                            }
                            
                            //self.meetings = JSON(snapshot.value)

                            }, withCancelBlock: { error in
                                print(error.description)
                        })
                        
                    }
                }, withCancelBlock: {error in
                    print(error.description)
                })
                    
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let localCell = tableView.dequeueReusableCellWithIdentifier("meeting") as! MeetingCell
        
        localCell.title.text = currentMeetings[indexPath.row].meetingTitle
        localCell.date.text = currentMeetings[indexPath.row].date
        localCell.networkGroupName.text = currentMeetings[indexPath.row].name
        
        var statusText: String
        if currentMeetings[indexPath.row].status == 0 {
            statusText = "Ikke svaret"
        } else if (currentMeetings[indexPath.row].status == (-1)) {
            statusText = "Afvist"
        } else {
            statusText = "Tilmeldt"
        }
        
        localCell.status.text = statusText
        
        return localCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentMeetings.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0.1)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndexSelected = indexPath
        performSegueWithIdentifier("meetingSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "meetingSegue" {
            let toViewController = segue.destinationViewController as! MeetingViewController
            let meet = self.currentMeetings[lastIndexSelected.row]
            print(meet.meetingTitle)
            toViewController.meet = meet
            toViewController.fromVC = "ViewController"
            //toViewController.transitioningDelegate = self.transitionManager
        }
    }

    // Utillity functions
    
    // Set the array of current meetings
    func setCurrent() {
        currentMeetings.removeAll()
        for meet in self.meetings {
            if segment.selectedSegmentIndex == 0 {
                if meet.status == 1 {
                    currentMeetings.append(meet)
                }
            } else if (segment.selectedSegmentIndex == 1) {
                if meet.status == -1 {
                    currentMeetings.append(meet)
                }
            } else {
                if meet.status == 0 {
                    currentMeetings.append(meet)
                }
            }
        }
        self.currentMeetings.sortInPlace()
    }
    
}













//        myRootRef.runTransactionBlock({
//            (currentData:FMutableData!) in
//
//            print(currentData.description)
//            let group = currentData.childDataByAppendingPath("networkgroups/g4s/members/006/status")
//            group.value = "aktiv"
//
//            let user = currentData.childDataByAppendingPath("users/006/ngroup/g4s")
//            user.value = "passiv"
//
//            return FTransactionResult.successWithValue(currentData)
//        })

// Write data to Firebase
//        let ngroup = ["g4s": "true"]
//
//        let user = ["name": "NetworkGuy", "age": "30", "ngroup": ngroup]
//
//myRootRef.
//
//        myRootRef.observeSingleEventOfType(.Value, withBlock: {
//            snapshot in
//
//            let path = snapshot.value as! String
//
//            let str = ("https://brilliant-torch-4963.firebaseio.com" + path)
//
//            let specificPath = Firebase(url:str)
//
//            specificPath.observeSingleEventOfType(.Value, withBlock: {
//                snapshot in
//
//                let status = snapshot.value
//
//                print(status)
//            })
//
//        })



//print(status)

//myRootRef.childByAppendingPath("005/ngroup").updateChildValues()