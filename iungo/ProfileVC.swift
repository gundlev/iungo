//
//  ProfileVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 09/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
import MapKit


class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    var fromVC = ""
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // User Object (Set in prepare for segue)
    var user:User = User(uname: "Niklas S. Gundlev", ucompany: "Awesome Apps Inc.", uuserId: "000", uuserTitle: "CEO", uaddress: "Tagensvej 59, 2200 København N", uphoneNo: "31585010", umobilNo: "12345678", uemail: "Niklas@gundlev.dk", uwebsite: "http://www.gundlev.dk", UImage: UIImage(named: "defaultProfileImage")!, uuserDescription: "I make awesome apps that are always working perfectly (mostly)", ustatus: "0")
    
    //UIImage(data: NSData(base64EncodedString: "Base64 string here!", options: NSDataBase64DecodingOptions(rawValue: 0))!)!
    
    // VC Elements
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func finishedEditingProfile(sender: UIStoryboardSegue) {
        setUser()
        tableview.reloadData()
    }
    
    @IBAction func editPressed(sender: AnyObject) {
        performSegueWithIdentifier("editProfile", sender: self)
    }
    
    // Buttons from cells
    
    @IBAction func callPhone(sender: AnyObject) {
        
        let phone = "tel://" + user.phoneNo!;
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }
    
    @IBAction func callMobil(sender: AnyObject) {
        
        let phone = "tel://" + user.phoneNo!; // TODO: change to mobil number)
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }
    
    @IBAction func textMobil(sender: AnyObject) {
        self.sendSMS()
    }

    @IBAction func sendEmail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func goToWebsite(sender: AnyObject) {
        var stringUrl = self.user.website!
        let index = stringUrl.startIndex.advancedBy(7)
        
        let stringCut = stringUrl.substringToIndex(index)
        print(stringCut)
        if (stringCut != "http://") {
            stringUrl = "http://" + stringUrl
        }
        let url = NSURL(string: stringUrl)
        print(url)
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func showRoute(sender: AnyObject) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(user.address!) { (placemarks, error) -> Void in
            
            let placemark = placemarks![0]
            
            let mkPlacemark: MKPlacemark = MKPlacemark(placemark: placemark)
            
            let mapItem = MKMapItem(placemark: mkPlacemark)
            
            mapItem.name = "Vej til " + self.user.name
            
            //You could also choose: MKLaunchOptionsDirectionsModeWalking
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            
            mapItem.openInMapsWithLaunchOptions(launchOptions)
            
        }

    }
    
    func goBack() {
        if fromVC == "partList" {
            performSegueWithIdentifier("backToPartList", sender: self)
        } else if fromVC == "wall" {
            performSegueWithIdentifier("backToWall", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        
        // Set up NavigationController
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 143/255, blue: 170/255, alpha: 1)
        
        
        // Set up menu
        if fromVC == "partList" || fromVC == "wall" {
            menu.image = UIImage(named: "Back")
            menu.action = Selector("goBack")
            menu.target = self
            self.navigationItem.rightBarButtonItem = nil
        } else if fromVC == "" {
            menu.target = self.revealViewController()
            menu.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Get user fra the defaults
            self.setUser()
            
        }

        
        
        // set up tableview
        tableview.contentInset = UIEdgeInsetsZero
        tableview.delaysContentTouches = false
    }
    
    func setUser() {
        var profileImage = UIImage(named: "defaultProfileImage")
        
        let imageString = userDefaults.stringForKey("picture")!
        
        if imageString != "" {
            profileImage = UIImage(data: NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions(rawValue: 0))!)
        }
        
        self.user = User(uname: userDefaults.stringForKey("name")!, ucompany: userDefaults.stringForKey("company")!, uuserId: userDefaults.stringForKey("uid")!, uuserTitle: userDefaults.stringForKey("title")!, uaddress: userDefaults.stringForKey("address")!, uphoneNo: userDefaults.stringForKey("phoneNo")!, umobilNo: userDefaults.stringForKey("mobilNo")!, uemail: userDefaults.stringForKey("email")!, uwebsite: userDefaults.stringForKey("website")!, UImage: profileImage!, uuserDescription: userDefaults.stringForKey("description")!, ustatus: "0")

    }
    
    // Tableview methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var top: ProfileTopCell
        var contact: ProfileContactCell
        var address: ProfileAddressCell
        var description: ProfileDescriptionCell
        
        switch indexPath.row {
        case 0:
            top = tableView.dequeueReusableCellWithIdentifier("profileTopCell") as! ProfileTopCell
            top.VC = self
            top.profileImage.image = user.profileImage
            top.name.text = user.name
            if user.company == "" {
                top.company.text = "Ikke angivet"
                top.company.alpha = 0.5
            } else {
                top.company.text = user.company
            }
            
            if user.userTitle == "" {
                top.userTitle.text = "Ikke angivet"
                top.userTitle.alpha = 0.5
            } else {
                top.userTitle.text = user.userTitle
            }
            
            
            return top
        case 1:
            contact = tableView.dequeueReusableCellWithIdentifier("profileContactCell") as! ProfileContactCell
            if user.phoneNo == "" {
                contact.phoneNo.alpha = 0.5
                contact.phoneNo.text = "Ikke angivet"
                contact.iconOffice.alpha = 0.5
                contact.iconOffice.enabled = false
            } else {
                contact.phoneNo.text = user.phoneNo
            }
            
            if user.mobilNo == "" {
                contact.mobilNo.alpha = 0.5
                contact.mobilNo.text = "Ikke angivet"
                contact.iconMobil.alpha = 0.5
                contact.iconMobil.enabled = false
                contact.iconMobilSMS.alpha = 0.5
                contact.iconMobilSMS.enabled = false
            } else {
                contact.mobilNo.text = user.mobilNo
            }
            
            if user.email == "" {
                contact.email.alpha = 0.5
                contact.email.text = "Ikke angivet"
                contact.iconEmail.alpha = 0.5
                contact.iconEmail.enabled = false
            } else {
                contact.email.text = user.email
            }
            
            if user.website == "" {
                contact.website.alpha = 0.5
                contact.website.text = "Ikke angivet"
                contact.iconWebsite.alpha = 0.5
                contact.iconWebsite.enabled = false
            } else {
                contact.website.text = user.website
            }
            
            if fromVC == "" {
                contact.iconEmail.hidden = true
                contact.iconMobil.hidden = true
                contact.iconMobilSMS.hidden = true
                contact.iconOffice.hidden = true
                contact.iconWebsite.hidden = true
            }
            
            return contact
        case 2:
            address = tableView.dequeueReusableCellWithIdentifier("profileAddressCell") as! ProfileAddressCell
            
            if user.address == "" {
                address.address.alpha = 0.5
                address.address.text = "Ikke angivet"
                address.iconVisVej.alpha = 0.5
                address.iconVisVej.enabled = false
            } else {
                address.address.text = user.address
            }
            return address
        default:
            description = tableView.dequeueReusableCellWithIdentifier("profileDescriptionCell") as! ProfileDescriptionCell
            
            if user.userDescription == "" {
                description.profileDescription.text = "Ikke angivet"
                description.profileDescription.alpha = 0.5
            } else {
                description.profileDescription.text = user.userDescription
            }
            
            return description
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return CGFloat(300)
        case 1: return CGFloat(180)
        case 2: return CGFloat(99)
        default: return CGFloat(280)
        }
    }
    
    
    // Message/SMS methods
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message Cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message Failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message Sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    func sendSMS() {
        let messageVC = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            messageVC.body = ""
            messageVC.recipients = [user.mobilNo!] //TODO: change to mobilNo when its ready
            messageVC.messageComposeDelegate = self;
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
    }
    
    
    // Email methods
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([user.email!])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfile" {
            let vc = segue.destinationViewController as! ProfileEditVC
            vc.user = self.user
        }
    }
}
