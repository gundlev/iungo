//
//  MeetVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 31/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

// NOT IN USE AT THE MOMENT!!!

import UIKit
import Firebase
import SwiftyJSON


class MeetVC: UIViewController {

    let userid = "004"
    var meetings: [Meeting] = [Meeting]()
    var groups: [String] = [""]
    var currentMeetings: [Meeting] = [Meeting]()
    let transitionManager = TransitionManager()
    var lastIndexSelected: NSIndexPath = NSIndexPath()
    
    @IBAction func segmentChanged(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up menu
        //        menu.target = self.revealViewController()
        //        menu.action = Selector("revealToggle:")
        //        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //
        groups.removeAll()
        
        // Find array of groups from the specefic user
        let url = "https://brilliant-torch-4963.firebaseio.com/users/" + userid + "/ngroup"
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
                ngroupRef.observeEventType(.Value, withBlock: {snapshot in
                    
                    // Check if active
                    if snapshot.value as! String == "aktiv" {
                        // The user us active, so get the meetings from that group
                        let specificUrl = "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + groupName + "/meetings"
                        
                        let ref = Firebase(url: specificUrl)
                        // TODO: make this a single download event
                        ref.queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
                            
                            self.meetings.removeAll()
                            
                            let json = JSON(snapshot.value)
                            
                            // Create meeting objects for all meetings, and add them to the meetings array.
                            for (key, subJson) in json {
                                let meeting = Meeting(oid: key, otitle: subJson["title"].stringValue, otext: subJson["text"].stringValue, odate: subJson["date"].stringValue, otime: subJson["time"].stringValue, oaddress: subJson["address"].stringValue, oname: groupName)
                                
                                for (subkey, subsubJson) in subJson["participants"] {
                                    meeting.setParticipant(key, status: subsubJson["status"].intValue)
                                    if subkey == self.userid {
                                        meeting.status = subsubJson["status"].intValue
                                    }
                                }
                                
                                self.meetings.append(meeting)
                            }
                            
                            //self.meetings = JSON(snapshot.value)
                            self.setCurrent()
                            self.tableview.reloadData()
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
        
        // Create a reference to a Firebase location
        let ref = Firebase(url:"https://brilliant-torch-4963.firebaseio.com/networkgroups/g4s/meetings")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let localCell = tableView.dequeueReusableCellWithIdentifier("meeting") as! MeetingCell
        
        localCell.title.text = currentMeetings[indexPath.row].meetingTitle
        localCell.date.text = "Date: " + currentMeetings[indexPath.row].date
        
        var statusText: String
        if currentMeetings[indexPath.row].status == 0 {
            statusText = "Maybe"
        } else if (currentMeetings[indexPath.row].status == (-1)) {
            statusText = "Declined"
        } else {
            statusText = "Accepted"
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
        print("reaches here")
        lastIndexSelected = indexPath
        performSegueWithIdentifier("meetingSegue3", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "meetingSegue2" {
            let toViewController = segue.destinationViewController as! MeetingViewController
            let meet = self.currentMeetings[lastIndexSelected.row]
            print(meet.meetingTitle)
            toViewController.meet = meet
            toViewController.transitioningDelegate = self.transitionManager
        } else if segue.identifier == "meetingSegue3" {
            let toViewController = segue.destinationViewController as! UIViewController
            toViewController.transitioningDelegate = self.transitionManager
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
    

