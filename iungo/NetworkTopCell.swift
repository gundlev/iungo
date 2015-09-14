//
//  NetworkTopCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 20/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class NetworkTopCell: UITableViewCell {
    
    @IBOutlet weak var networkImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UITextView!
    
    override func awakeFromNib() {
        networkImage.layer.borderWidth = 1
        networkImage.layer.masksToBounds = false
        networkImage.layer.borderColor = UIColor.whiteColor().CGColor
        networkImage.layer.cornerRadius = networkImage.frame.height/2
        networkImage.clipsToBounds = true
    }
}
