//  ProfileEditContactCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 10/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ProfileEditContactCell: UITableViewCell {
    
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var mobilNo: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var website: UITextField!

    override func awakeFromNib() {
        phoneNo.attributedPlaceholder = NSAttributedString(string:"Kontor tlf.",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
        mobilNo.attributedPlaceholder = NSAttributedString(string:"Mobil tlf.",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
        email.attributedPlaceholder = NSAttributedString(string:"Email",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
        website.attributedPlaceholder = NSAttributedString(string:"Website",
            attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)])
    }
}
