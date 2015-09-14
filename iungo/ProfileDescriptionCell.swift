//
//  ProfileDescriptionCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 11/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ProfileDescriptionCell: UITableViewCell {

    @IBOutlet weak var profileDescription: UITextView!
    
    override func awakeFromNib() {
        profileDescription.textColor = UIColor.whiteColor()
    }
}
