//
//  MeetingAgenda.swift
//  iungo
//
//  Created by Niklas Gundlev on 22/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class MeetingAgenda: UITableViewCell {

    @IBOutlet weak var textBox: UITextView!
    
    override func awakeFromNib() {
        textBox.textColor = UIColor.whiteColor()
    }
    
}
