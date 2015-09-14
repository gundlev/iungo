//
//  ProfileEditUserCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 10/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ProfileEditUserCell: UITableViewCell {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        name.attributedPlaceholder = NSAttributedString(string:"Name",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
        title.attributedPlaceholder = NSAttributedString(string:"Titel",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
        company.attributedPlaceholder = NSAttributedString(string:"Firma",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
    }
}
