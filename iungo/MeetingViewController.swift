//
//  MeetingViewController.swift
//  iungo
//
//  Created by Niklas Gundlev on 21/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

//TODO: Implement a observeEvent for the specific meeting in order to track changes.
//TODO: Number of participants signed up for the meeting. Look through the entire list of participants and find all with a 1. DONE!

import UIKit
import EventKit

class MeetingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func saveCal(sender: UIButton) {
        // 1
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            insertEvent(eventStore)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                {(granted: Bool, error: NSError?) -> Void in
                    if granted {
                        self.insertEvent(eventStore)
                    } else {
                        print("Access denied")
                    }
                })
        default:
            print("Case Default")
        }
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        
        if fromVC == "ViewController" {
            performSegueWithIdentifier("backToMeetings", sender: self)
        } else if fromVC == "wall" {
            performSegueWithIdentifier("backToWall", sender: self)
        }
        
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        
        if self.segment.selectedSegmentIndex == 0 {
            self.meet.status = 1
            self.meet.numberOfParticipating++
        } else if self.segment.selectedSegmentIndex == 1 {
            self.meet.status = -1
            self.meet.numberOfParticipating--
        }
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let thisUrl = "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + meet.groupId + "/meetings/" + meet.id + "/participants/" + userDefaults.stringForKey("uid")!
        
        let ref = Firebase(url: thisUrl)
        
        let updatedStatus = ["status": meet.status]
        
        ref.updateChildValues(updatedStatus, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                print("Data could not be saved.")
                self.alert("Intet Internet", alertMessage: "Du har ingen internetforbindelse. Opret forbindelse og prøv igen.", actionTitle: "OK")
            } else {
                print("Data saved successfully!")
                self.tableView.reloadData()
            }
        })
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let transitionManager = TransitionManager()
    
    var fromVC = ""
    
    var meet: Meeting = Meeting(oid: "000", ogroupId: "000", otitle: "Test", otext: "Test", ostart: 000, oend: 000, oaddress: "Test", oname: "Test", onumber: 0)
    
    
    override func viewDidLoad() {
        
        tableView.contentInset = UIEdgeInsetsZero
        tableView.delaysContentTouches = false
        //let segue = UIStoryboardSegue(identifier: nil, source: self, destination: fromVC!)
        
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationItem.hidesBackButton = true
        if meet.status == 1 {
            segment.selectedSegmentIndex = 0
        } else if meet.status == -1 {
            segment.selectedSegmentIndex = 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var top: MeetingTop
        var place: MeetingPlace
        var info: MeetingInfo
        var agenda: MeetingAgenda
        var button: MeetingButton
        
        switch indexPath.row {
        case 0:
            print("case 1")
            top = tableView.dequeueReusableCellWithIdentifier("meetingTop") as! MeetingTop
            return top
        case 1:
            print("case 2")
            place = tableView.dequeueReusableCellWithIdentifier("meetingPlace") as! MeetingPlace
            place.address.text = meet.address
            place.name.text = "Netværk: " + meet.name
            place.meetingTitle.text = meet.meetingTitle
            return place
        case 2:
            print("case 3")
            info = tableView.dequeueReusableCellWithIdentifier("meetingInfo") as! MeetingInfo
            
            let startDate = NSDate(timeIntervalSince1970: NSTimeInterval(meet.startTimestamp!))
            let endDate = NSDate(timeIntervalSince1970: NSTimeInterval(meet.endTimestamp!))
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateText = dateFormatter.stringFromDate(startDate)
            
            let startTimeFormatter = NSDateFormatter()
            startTimeFormatter.dateFormat = "HH:mm"
            let startTimeText = startTimeFormatter.stringFromDate(startDate)
            
            let endTimeFormatter = NSDateFormatter()
            endTimeFormatter.dateFormat = "HH:mm"
            let endTimeText = endTimeFormatter.stringFromDate(endDate)
            
            let timeText = startTimeText + " - " + endTimeText
            
            
            info.date.text = dateText
            info.time.text = timeText
            
            var statusText: String
            if meet.status == 0 {
                statusText = "Ikke Svaret"
            } else if (meet.status == (-1)) {
                statusText = "Afvist"
            } else {
                statusText = "Tilmeldt"
            }
            info.status.text = statusText
            info.numberOfPart.text = String(meet.numberOfParticipating)
            return info
        case 3:
            print("default")
            agenda = tableView.dequeueReusableCellWithIdentifier("meetingAgenda") as! MeetingAgenda
            agenda.textBox.text = meet.meetingText
            agenda.textBox.textColor = UIColor.whiteColor()
            return agenda
        default:
            button = tableView.dequeueReusableCellWithIdentifier("meetingButton") as! MeetingButton
            return button
        }
        
//        for obj in place.subviews {
//            
//            if NSStringFromClass(obj) == "UITableViewCellScrollView" {
//                let scrollView = obj as! UIScrollView
//                
//                scrollView.delaysContentTouches = false
//            }
//        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return CGFloat(44)
        case 1: return CGFloat(140)
        case 2: return CGFloat(180)
        case 3: return CGFloat(180)
        default: return CGFloat(65)
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    
    @IBAction func exittingTheCurrentView2(sender: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "meetingList" {
            let toViewController = segue.destinationViewController as! ListVC
            print(meet.participants)
            toViewController.url = "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + meet.groupId + "/meetings/" + meet.id + "/participants/"
            toViewController.participants = meet.participants.count
            toViewController.from = "meeting"
            //toViewController.transitioningDelegate = self.transitionManager
        }
    }
    
    // Utility functions
    
    // Send alert.
    func alert(alertTitle: String, alertMessage: String, actionTitle: String) {
        let alertController = UIAlertController(title: alertTitle, message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // save Calendar Event
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
            as [EKCalendar]

        
        for calendar in calendars {
            // 2
            if calendar.title == "IUNGO" {
                // 3
                
                // 4
                // Create Event
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                let timeInterval = meet.time
                let timeArray = timeInterval.componentsSeparatedByString("-")
                let startString = meet.date + timeArray[0]
                print(startString)
                let endString = meet.date + timeArray[1]
                print(endString)
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy.MM.ddHH:mm"
                let startDate = formatter.dateFromString(startString)
                let endDate = formatter.dateFromString(endString)
                
                event.title = meet.name
                event.location = meet.address
                event.startDate = startDate!
                event.endDate = endDate!
                
                // 5
                // Save Event in Calendar
                do {
                    try store.saveEvent(event, span: EKSpan.ThisEvent)
                    self.alert("Mødet er gemt!", alertMessage: "Vær opmærksom på at mødet i din kalender ikke syncroniseres", actionTitle: "OK")
                } catch {
                    print("The Event could not be stored.")
                }
                
            }
        }
    }
    
}
