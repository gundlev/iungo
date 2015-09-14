//
//  MeetingPlace.swift
//  iungo
//
//  Created by Niklas Gundlev on 22/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MeetingPlace: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var meetingTitle: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBAction func visVej(sender: UIButton) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address.text!) { (placemarks, error) -> Void in
            
            let placemark = placemarks![0]
            
            let mkPlacemark: MKPlacemark = MKPlacemark(placemark: placemark)
            
            let mapItem = MKMapItem(placemark: mkPlacemark)
            
            mapItem.name = "Vej til " + self.name.text! + " møde"
            
            //You could also choose: MKLaunchOptionsDirectionsModeWalking
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            
            mapItem.openInMapsWithLaunchOptions(launchOptions)
            
        }
        
    }

}
