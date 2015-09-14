//
//  ProfileEditTopCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 10/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
// NOT IN USE

import UIKit

class ProfileEditTopCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBAction func ChangeProfileImage(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
}
