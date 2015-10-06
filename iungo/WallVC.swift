//
//  WallVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 03/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import Firebase
import EventKitUI

class WallVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: CustomTableView!
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBAction func backToWall(sender: UIStoryboardSegue) {
        self.tableview.deselectRowAtIndexPath(lastIndexPath!, animated: true)
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var notifications = [Noti]()
    var notiSelected: Noti?
    var lastIndexPath: NSIndexPath?
    
    
    override func viewDidLoad() {
        
        
        // Get permission for notifications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        tableview.contentInset = UIEdgeInsetsZero
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
        
        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/notifications")
        //print("\n\n" + userDefaults.stringForKey("uid")!)
        let uid = userDefaults.stringForKey("uid")!
        ref.queryOrderedByChild("to").queryEqualToValue(uid).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            //print("\n\nHere are the notifications")
//            print(snapshot.key)
//            print(snapshot.value)
            let json = JSON(snapshot.value)
            
            
            let noti = Noti(nnotiText: json["title"].stringValue, nfrom: json["from"].stringValue, nnotiId: snapshot.key, nread: json["read"].boolValue, nreference: json["reference"].stringValue, ntimestamp: json["timestamp"].stringValue, ntype: json["type"].stringValue, nfromName: json["fromName"].stringValue)
            
                let reference = Firebase(url: "https://brilliant-torch-4963.firebaseio.com" + json["reference"].stringValue)
                //print("https://brilliant-torch-4963.firebaseio.com" + json["reference"].stringValue)
                reference.observeSingleEventOfType(.Value, withBlock: { referenceData in
                    
                    //print("Here is the key" + referenceData.key)
                    //print(referenceData.value)
                    switch json["type"].stringValue {
                    case "newMeeting":
                        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + json["from"].stringValue)
                        ref.observeSingleEventOfType(.Value, withBlock: { groupData in
                            var groupJson = JSON(groupData.value)
                            noti.meeting = Meeting.jsonToMeeting(JSON(referenceData.value), mid:referenceData.key, network:groupJson["name"].stringValue, groupId: json["from"].stringValue)
                        })
                    case "newMember":
                        noti.user = User.jsonToUser(JSON(referenceData.value), userId:referenceData.key)
                    case "meetingUpdate":
                        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + json["from"].stringValue)
                        ref.observeSingleEventOfType(.Value, withBlock: { groupData in
                            var groupJson = JSON(groupData.value)
                            noti.meeting = Meeting.jsonToMeeting(JSON(referenceData.value), mid:referenceData.key, network:groupJson["name"].stringValue, groupId: json["from"].stringValue)
                        })
                    case "reminder":
                        let ref = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + json["from"].stringValue)
                        ref.observeSingleEventOfType(.Value, withBlock: { groupData in
                            var groupJson = JSON(groupData.value)
                            noti.meeting = Meeting.jsonToMeeting(JSON(referenceData.value), mid:referenceData.key, network:groupJson["name"].stringValue, groupId: json["from"].stringValue)
                        })
                    default:
                        print("Some other type")
                    }
                })

            
            self.notifications.append(noti)
            self.notifications.sortInPlace()
            self.notifications = self.notifications.reverse()
            self.tableview.reloadData()
        })
        
        if userDefaults.boolForKey("MustEditProfile") {
            let profileAlert = UIAlertController(title: "Der mangler vigtige oplysninger i din profil", message: "Husk at du indtaste det du mangler.", preferredStyle: .Alert)
            profileAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            userDefaults.setBool(false, forKey: "MustEditProfile")
            self.presentViewController(profileAlert, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as! NotificationCell
        
        var prefix = ""
        
        switch notifications[indexPath.row].type {
        case "newMeeting":
            prefix = " - Nyt møde tilføjet"
        case "newMember":
            prefix = " - Nyt medlem"
        case "meetingUpdate":
            prefix = " - Møde opdateret"
        case "reminder":
            prefix = " - Reminder"
        default:
            print("Some other type")
        }

        if notifications[indexPath.row].read {
            print("Read")
            cell.dot.hidden = true
        } else {
            cell.dot.hidden = false
            print("Not read")
        }
        
        // create new date object and format. Then format the date object from timestamp and check if same day. if so just write time if in same week write day else write date. (maybe days ago)
        
        
        // Getting number of days since
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(notifications[indexPath.row].timestamp)!/1000)
        let now = NSDate()
        let cal = NSCalendar.currentCalendar()
        let components = cal.components(.Day, fromDate: date, toDate: now, options: [])
        var numberOfDays:String = components.description
        numberOfDays.removeRange(Range<String.Index>(start: numberOfDays.startIndex, end: numberOfDays.endIndex.advancedBy((-1))))
        print(numberOfDays)
        
        var timeText = ""
        if numberOfDays == "0" {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeText = dateFormatter.stringFromDate(date)
        } else {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d. MMM"
            timeText = dateFormatter.stringFromDate(date)
        }
        
        cell.cellTitle.text = (notifications[indexPath.row].fromName + prefix)
        cell.cellText.text = notifications[indexPath.row].notiText
        cell.time.text = timeText
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("\nNumber of cells: ")
        print(notifications.count)
        return notifications.count
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set notification to read
        print("Setting read to true")
        let url = "https://brilliant-torch-4963.firebaseio.com/notifications/" + notifications[indexPath.row].notiId
        let userUrl = "https://brilliant-torch-4963.firebaseio.com/users/" + userDefaults.stringForKey("uid")!
        print("This is the user URL: " + userUrl)
        print(url)
        let userRef = Firebase(url: userUrl)
        
        if !notifications[indexPath.row].read {
            userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let userJson = JSON(snapshot.value)
            if userJson["notifications"].intValue > 0 {
                let number = userJson["notifications"].intValue - 1
                userRef.childByAppendingPath("notifications").setValue(number)
                UIApplication.sharedApplication().applicationIconBadgeNumber = number
            }
            
            })
        }
        
        
        let ref = Firebase(url: url)
        ref.childByAppendingPath("read").setValue(true)
        
        self.lastIndexPath = indexPath
        notiSelected = notifications[indexPath.row]
        notifications[indexPath.row].read = true
        
        switch notifications[indexPath.row].type {
        case "newMeeting":
            performSegueWithIdentifier("wallToMeeting", sender: self)
        case "newMember":
            performSegueWithIdentifier("wallToUser", sender: self)
        case "meetingUpdate":
            performSegueWithIdentifier("wallToMeeting", sender: self)
        case "reminder":
            performSegueWithIdentifier("wallToMeeting", sender: self)
        default:
            print("Some other type")
        }
        tableview.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "wallToMeeting":
                
                
                let VC = segue.destinationViewController as! MeetingViewController
                VC.meet = notiSelected!.meeting!
                VC.fromVC = "wall"
            case "wallToUser":
                let VC = segue.destinationViewController as! ProfileVC
                VC.user = notiSelected!.user!
                VC.fromVC = "wall"
        default:
            print("default")
        }
    }
}
