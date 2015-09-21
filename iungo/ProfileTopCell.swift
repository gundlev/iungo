//
//  ProfileTopCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 11/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ProfileTopCell: UITableViewCell {
    
    var VC: ProfileVC?
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func ImageButton(sender: AnyObject) {
        print("image pressed")
        var imageInfo = JTSImageInfo()
        imageInfo.image = self.profileImage.image
        imageInfo.referenceRect = self.profileImage.frame
        imageInfo.referenceView = self.profileImage.superview
        imageInfo.referenceContentMode = self.profileImage.contentMode
        imageInfo.referenceCornerRadius = self.profileImage.layer.cornerRadius
        
        var imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        
        imageViewer.showFromViewController(VC!, transition: JTSImageViewControllerTransition.FromOriginalPosition)
    }

    @IBOutlet weak var name: B68UIFloatLabelTextField!
   // @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var userTitle: B68UIFloatLabelTextField!
    //@IBOutlet weak var userTitle: UILabel!

    @IBOutlet weak var company: B68UIFloatLabelTextField!
    //@IBOutlet weak var company: UILabel!
    
    override func awakeFromNib() {
        
        // Making Image Round and setting border
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        
    }

}
