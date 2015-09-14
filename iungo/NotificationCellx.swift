//
//  NotificationCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 03/09/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let hView = UIView()
        hView.frame = self.frame
        hView.backgroundColor = UIColor(red: 40/255, green: 125/255, blue: 156/255, alpha: 1)
        
        self.selectedBackgroundView = hView
        
    }
}
