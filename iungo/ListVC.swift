//
//  ListVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 01/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import Firebase

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func back(sender: UIBarButtonItem) {
        if from == "network" {
            performSegueWithIdentifier("backToNetwork", sender: self)
        } else {
            performSegueWithIdentifier("backToMeeting", sender: self)
        }
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        self.setCurrent()
        self.tableview.reloadData()
    }
    
    @IBAction func exittingToPartList(sender: UIStoryboardSegue) {
        self.tableview.deselectRowAtIndexPath(lastIndexSelected, animated: true)
    }
    
    var lastIndexSelected = NSIndexPath()
    //var participants: [Dictionary<String,Int>] = []
    var participants = 0
    var url = ""
    var pJson = JSON("")
    var fullyLoaded = false
    var fullList: [User] = []
    var currentList: [User] = []
    var from = ""
    
    override func viewDidLoad() {
        
        if from == "network" {
            segment.removeSegmentAtIndex(3, animated: false)
            segment.removeSegmentAtIndex(2, animated: false)
            segment.setTitle("Aktiv", forSegmentAtIndex: 0)
            segment.setTitle("Ikke Aktiv", forSegmentAtIndex: 1)
        }
        
        self.navigationItem.hidesBackButton = true
        tableview.contentInset = UIEdgeInsetsZero
        
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        let participantsRef = Firebase(url: url)
        print("This is the url:")
        print(url)
        
        participantsRef.observeEventType(.Value, withBlock: {snapshot in
            
            self.pJson = JSON(snapshot.value)
            
            for (userId, status) in self.pJson {
                
                print(userId)
                
                
                let userRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/users/" + userId)
                userRef.observeEventType(.Value, withBlock: {snapshot in
                    
                    var user = JSON(snapshot.value)
                    
                    //let userArray = [user["name"].stringValue, user["company"].stringValue, status]
                    self.fullList.append(User(uname: user["name"].stringValue, ucompany: user["company"].stringValue, uuserId: userId, uuserTitle: user["title"].stringValue, uaddress: user["address"].stringValue, uphoneNo: user["phoneNo"].stringValue, umobilNo:user["mobilNo"].stringValue, uemail: user["email"].stringValue, uwebsite: user["website"].stringValue, UImage: UIImage(named: "defaultProfileImage")!, uuserDescription:user["description"].stringValue , ustatus: status["status"].stringValue))

//                    self.fullList.sortInPlace()
//                    self.tableview.reloadData()
                    
                    if self.fullList.count == self.participants {
                        self.fullyLoaded = true
                        self.fullList.sortInPlace()
                        self.currentList = self.fullList
                        self.tableview.reloadData()
                    }
                    
                    
                }, withCancelBlock: {error in
                    print(error.description)
                })
            }
        })
        
        //for (key, value) in participants {
            
        //}
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("meetingListCell") as! ListCell
        
//        let user = currentList[indexPath.row]
//        
//        cell.name.text = user.name
//        cell.company.text = user.company
//        cell.imageview.image = user.profileImage
//        
//        var statusText: String
//        if user.meetingStatus == "0" {
//            statusText = "Ikke svaret"
//        } else if (user.meetingStatus == "-1") {
//            statusText = "Ikke Tilmeldt"
//        } else if user.meetingStatus == "1" {
//            statusText = "Tilmeldt"
//        } else if user.meetingStatus == "aktiv" {
//            statusText = "Aktiv"
//        } else {
//            statusText = "Ikke Aktiv"
//        }
//        
//        cell.status.text = statusText
        
        if fullyLoaded {
        
            let user = currentList[indexPath.row]
            
            cell.name.text = user.name
            cell.company.text = user.company
            cell.imageview.image = user.profileImage
            
            var statusText: String
            if user.meetingStatus == "0" {
                statusText = "Ikke svaret"
            } else if (user.meetingStatus == "-1") {
                statusText = "Ikke Tilmeldt"
            } else if user.meetingStatus == "1" {
                statusText = "Tilmeldt"
            } else if user.meetingStatus == "aktiv" {
                statusText = "Aktiv"
            } else {
                statusText = "Ikke Aktiv"
            }
            
            cell.status.text = statusText
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !fullyLoaded {
            return 0
        } else {
            return self.currentList.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndexSelected = indexPath
        performSegueWithIdentifier("listToProfile", sender: self)
    }
    
    // Set the array of current users
    func setCurrent() {
        currentList.removeAll()
        
        if from == "meeting" {
            for user in self.fullList {
                if segment.selectedSegmentIndex == 0 {
                    currentList = fullList
                } else if (segment.selectedSegmentIndex == 1) {
                    if user.meetingStatus == "1" {
                        currentList.append(user)
                    }
                } else if (segment.selectedSegmentIndex == 2) {
                    if user.meetingStatus == "-1" {
                        currentList.append(user)
                    }
                } else if (segment.selectedSegmentIndex == 3) {
                    if user.meetingStatus == "0" {
                        currentList.append(user)
                    }
                }
            }
        } else if from == "network" {
            for user in self.fullList {
                if segment.selectedSegmentIndex == 0 {
                    if user.meetingStatus == "aktiv" {
                        currentList.append(user)
                    }
                } else if (segment.selectedSegmentIndex == 1) {
                    if user.meetingStatus == "ikke aktiv" {
                        currentList.append(user)
                    }
                } 
            }
        }
        self.currentList.sortInPlace()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "listToProfile" {
            let toViewController = segue.destinationViewController as! ProfileVC
            
            toViewController.user = currentList[lastIndexSelected.row]
            
            toViewController.fromVC = "partList"
        }
    }
    
}
