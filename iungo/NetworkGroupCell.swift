//
//  NetworkGroupCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 19/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class NetworkGroupCell: UITableViewCell {

    @IBOutlet weak var networkName: UILabel!
    
    @IBOutlet weak var members: UILabel!
    
    @IBOutlet weak var userStatus: UILabel!
    
    @IBOutlet weak var networkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let hView = UIView()
        hView.frame = self.frame
        hView.backgroundColor = UIColor(red: 40/255, green: 125/255, blue: 156/255, alpha: 1)
        
        self.selectedBackgroundView = hView
        

        networkImage.layer.borderWidth = 0.3
        networkImage.layer.masksToBounds = false
        networkImage.layer.borderColor = UIColor.whiteColor().CGColor
        networkImage.layer.cornerRadius = networkImage.frame.height/2
        networkImage.clipsToBounds = true
        
        
    }
    
}
