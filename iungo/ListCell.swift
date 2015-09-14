//
//  ListCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 01/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let hView = UIView()
        hView.frame = self.frame
        hView.backgroundColor = UIColor(red: 40/255, green: 125/255, blue: 156/255, alpha: 1)
        
        self.selectedBackgroundView = hView
        
        imageview.layer.borderWidth = 0.3
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = UIColor.whiteColor().CGColor
        imageview.layer.cornerRadius = imageview.frame.height/2
        imageview.clipsToBounds = true
        
    }
}
