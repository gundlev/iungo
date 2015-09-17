//
//  NetworkGroupProfileVC.swift
//  iungo
//
//  Created by Niklas Gundlev on 20/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NetworkGroupProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var networkGroup: NetworkGroup?
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var tableView: CustomTableView!
    @IBAction func backButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("backToNetworkGroups", sender: self)
    }
    
    @IBAction func backToNetwork(sender: UIStoryboardSegue) {
    }
    
    @IBAction func showRoute(sender: UIButton) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(networkGroup!.address) { (placemarks, error) -> Void in
            
            let placemark = placemarks![0]
            
            let mkPlacemark: MKPlacemark = MKPlacemark(placemark: placemark)
            
            let mapItem = MKMapItem(placemark: mkPlacemark)
            
            mapItem.name = "Vej til " + self.networkGroup!.name
            
            //You could also choose: MKLaunchOptionsDirectionsModeWalking
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            
            mapItem.openInMapsWithLaunchOptions(launchOptions)
            
        }
    }
    
//    @IBAction func showMembers(sender: AnyObject) {
//        
//    }
    
    @IBAction func showMeetings(sender: UIButton) {
        performSegueWithIdentifier("networkToMeetings", sender: self)
    }
    
    override func viewDidLoad() {
        networkGroup?.printAll()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var top: NetworkTopCell
        var info: NetworkInfoCell
        var desc: NetworkDescriptionCell
        
        switch indexPath.row {
        case 0:
            top = tableView.dequeueReusableCellWithIdentifier("NetworkTopCell") as! NetworkTopCell
            top.name.text = networkGroup?.name
            top.address.text = networkGroup?.address
            top.networkImage.image = networkGroup?.networkImage
            return top
        case 1:
            info = tableView.dequeueReusableCellWithIdentifier("NetworkInfoCell") as! NetworkInfoCell
            info.meetingDay.text = networkGroup?.meetDay
            info.meetingFrequency.text = networkGroup?.meetingFrequency
            info.meetingTime.text = networkGroup?.meetTime
            info.members.text = String(networkGroup!.size)
            return info
        default:
            desc = tableView.dequeueReusableCellWithIdentifier("NetworkDescriptionCell") as! NetworkDescriptionCell
            desc.descriptionText.text = networkGroup?.networkDescription
            desc.descriptionText.textColor = UIColor.whiteColor()
            return desc
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return CGFloat(280)
        case 1: return CGFloat(175)
        default: return CGFloat(250)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMembers" {
            let toVC = segue.destinationViewController as! ListVC
            toVC.url = "https://brilliant-torch-4963.firebaseio.com/networkgroups/" + networkGroup!.id + "/members"
            toVC.from = "network"
            toVC.participants = networkGroup!.size
        } else if segue.identifier == "networkToMeetings" {
            let toVC = segue.destinationViewController as! ViewController
            toVC.fromVC = "network"
            toVC.fromNetworkId = (networkGroup?.id)!
            toVC.fromNetworkName = (networkGroup?.name)!
        }
    }
}
