//
//  ProfileTopCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 11/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ProfileTopCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var userTitle: UILabel!

    @IBOutlet weak var company: UILabel!
    
    override func awakeFromNib() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
}
