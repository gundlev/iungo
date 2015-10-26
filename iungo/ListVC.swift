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
    @IBOutlet weak var menu: UIBarButtonItem!
    
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
    let userDefaults = NSUserDefaults.standardUserDefaults()
    //var participants: [Dictionary<String,Int>] = []
    //var participants = 0
    var url = ""
    var urls = [String]()
    var pJson = JSON("")
    //var fullyLoaded = false
    var fullList: [User] = []
    var currentList: [User] = []
    var from = "menu"
    var userIds = [String]()
    
    
    func goBack() {
        print("This has been pressed")
        if from == "network" {
            performSegueWithIdentifier("backToNetwork", sender: self)
        } else {
            performSegueWithIdentifier("backToMeeting", sender: self)
        }
    }
    
    override func viewDidLoad() {
        
        if from == "menu" {
            self.navigationItem.hidesBackButton = true
            let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationController?.navigationBar.titleTextAttributes = titleDict
            self.navigationController?.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
            
            segment.removeSegmentAtIndex(3, animated: false)
            segment.removeSegmentAtIndex(2, animated: false)
            segment.setTitle("Aktiv", forSegmentAtIndex: 0)
            segment.setTitle("Ikke Aktiv", forSegmentAtIndex: 1)
            
            menu.target = self.revealViewController()
            menu.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        } else {
            menu.image = UIImage(named: "Back")
            menu.action = Selector("goBack")
            menu.target = self
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if from == "network" {
            segment.removeSegmentAtIndex(3, animated: false)
            segment.removeSegmentAtIndex(2, animated: false)
            segment.setTitle("Aktiv", forSegmentAtIndex: 0)
            segment.setTitle("Ikke Aktiv", forSegmentAtIndex: 1)
        } else if from == "menu" {
            
        }
        
        self.navigationItem.hidesBackButton = true
        tableview.contentInset = UIEdgeInsetsZero
        
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        if from == "menu" {
            let userid = userDefaults.stringForKey("uid")
            let userUrl = "https://brilliant-torch-4963.firebaseio.com/users/" + userid! + "/ngroup"
            let allgroupsRef = Firebase(url: userUrl)
            
            print(userUrl)
            
            allgroupsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                let json = JSON(snapshot.value)
                print(json)
                
                for (group, statusLink) in json {
                    
                    let newUrl: String = "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + group + "/members"
                    print(newUrl)
                    self.urls.append(newUrl)
                }
                
                self.getAllParticipants()
            })
        } else {
            self.getAllParticipants()
        }
        
        
        
        //for url in urls {
            
//            let participantsRef = Firebase(url: url)
//            print("This is the url:")
//            print(url)
//            
//            participantsRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
//                
//                self.pJson = JSON(snapshot.value)
//                
//                for (userId, status) in self.pJson {
//                    
//                    print(userId)
//                    
//                    
//                    let userRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/users/" + userId)
//                    userRef.observeEventType(.Value, withBlock: {snapshot in
//                        
//                        var user = JSON(snapshot.value)
//                        
//                        var profileImage = UIImage(named: "defaultProfileImage")!
//                        
//                        let imageString = user["picture"].stringValue
//                        
//                        print(userId)
//                        
//                        if imageString != "" {
//                            
//                            if let data = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
//                                if let img = UIImage(data: data) {
//                                    profileImage = img
//                                }
//                            }
//                            
//                        }
//                        
//                        //let userArray = [user["name"].stringValue, user["company"].stringValue, status]
//                        self.fullList.append(User(uname: user["name"].stringValue, ucompany: user["company"].stringValue, uuserId: userId, uuserTitle: user["title"].stringValue, uaddress: user["address"].stringValue, uphoneNo: user["phoneNo"].stringValue, umobilNo:user["mobilNo"].stringValue, uemail: user["email"].stringValue, uwebsite: user["website"].stringValue, UImage: profileImage, uuserDescription:user["description"].stringValue , ustatus: status["status"].stringValue))
//                        
//    //                    if self.fullList.count == self.participants {
//    //                        self.fullyLoaded = true
//    //                        self.fullList.sortInPlace()
//    //
//                            if self.from == "network" {
//                                self.currentList.removeAll()
//                                for user in self.fullList {
//                                    //currentList = fullList
//                                    if user.meetingStatus == "aktiv" {
//                                        self.currentList.append(user)
//                                    }
//                                }
//                            } else {
//                                self.currentList.removeAll()
//                                for user in self.fullList {
//                                    //currentList = fullList
//                                    if user.meetingStatus == "1" {
//                                        self.currentList.append(user)
//                                    }
//                                }
//                            }
//                        
//                            self.currentList.sortInPlace()
//                            self.tableview.reloadData()
//    //                        self.tableview.reloadData()
//    //                    }
//                        
//                        
//                    }, withCancelBlock: {error in
//                        print(error.description)
//                    })
//                }
//            })
//
      //  }
        
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
        
//        if fullyLoaded {
        
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
//        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return self.currentList.count
//        if !fullyLoaded {
//            return 0
//        } else {
//            return self.currentList.count
//        }
        
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
        let numberOfUsers = self.fullList.count
        
        if from == "menu" {
            for (var i = 0 ; i > numberOfUsers ; i++) {
                for (var j = 0 ; i+1 > numberOfUsers ; i++) {
                    if self.fullList[i].userId == self.fullList[j].userId {
                        self.fullList.removeAtIndex(i)
                    }
                }
            }
        }
        
        if from == "meeting" {
            for user in self.fullList {
                if segment.selectedSegmentIndex == 0 {
                    //currentList = fullList
                    if user.meetingStatus == "1" {
                        currentList.append(user)
                    }
                } else if (segment.selectedSegmentIndex == 1) {
                    if user.meetingStatus == "-1" {
                        currentList.append(user)
                    }
                } else if (segment.selectedSegmentIndex == 2) {
                    if user.meetingStatus == "0" {
                        currentList.append(user)
                    }
                }
            }
        } else if from == "network" || self.from == "menu" {
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

    func getAllParticipants() {
        
        for url in urls {
            
            let participantsRef = Firebase(url: url)
            print("This is the url:")
            print(url)
            
            participantsRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
                
                self.pJson = JSON(snapshot.value)
                
                for (userId, status) in self.pJson {
                    
                    print(userId)
                    
                    var notLoadedYet = true
                    for id in self.userIds {
                        if id == userId {
                            notLoadedYet = false
                        }
                    }
                    
                    let userRef = Firebase(url: "https://brilliant-torch-4963.firebaseio.com/users/" + userId)
//                    print(notLoadedYet)
                    
                    if notLoadedYet {
                        userRef.observeEventType(.Value, withBlock: {snapshot in
                            
                            var user = JSON(snapshot.value)
                            var profileImage = UIImage(named: "defaultProfileImage")!
                            let imageString = user["picture"].stringValue
                            print(userId)
                            if imageString != "" {
                                
                                if let data = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                                    if let img = UIImage(data: data) {
                                        profileImage = img
                                    }
                                }
                                
                            }
                            
                            //let userArray = [user["name"].stringValue, user["company"].stringValue, status]
                            self.fullList.append(User(uname: user["name"].stringValue, ucompany: user["company"].stringValue, uuserId: userId, uuserTitle: user["title"].stringValue, uaddress: user["address"].stringValue, uphoneNo: user["phoneNo"].stringValue, umobilNo:user["mobilNo"].stringValue, uemail: user["email"].stringValue, uwebsite: user["website"].stringValue, UImage: profileImage, uuserDescription:user["description"].stringValue , ustatus: status["status"].stringValue))
                            
                            //                    if self.fullList.count == self.participants {
                            //                        self.fullyLoaded = true
                            //                        self.fullList.sortInPlace()
                            //
//                            if self.from == "network" || self.from == "menu" {
//                                self.currentList.removeAll()
//                                for user in self.fullList {
//                                    //currentList = fullList
//                                    if user.meetingStatus == "aktiv" {
//                                        self.currentList.append(user)
//                                    }
//                                }
//                            } else {
//                                self.currentList.removeAll()
//                                for user in self.fullList {
//                                    //currentList = fullList
//                                    if user.meetingStatus == "1" {
//                                        self.currentList.append(user)
//                                    }
//                                }
//                            }
                            self.setCurrent()
                            
                            self.currentList.sortInPlace()
                            self.tableview.reloadData()
                            //                        self.tableview.reloadData()
                            //                    }
                            
                            
                            }, withCancelBlock: {error in
                                print(error.description)
                        })
                    }
                }
            })

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "listToProfile" {
            let toViewController = segue.destinationViewController as! ProfileVC
            
            toViewController.user = currentList[lastIndexSelected.row]
            
            toViewController.fromVC = "partList"
        }
    }
    
}
