//
//  MeetingCell.swift
//  iungo
//
//  Created by Niklas Gundlev on 20/07/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var networkGroupName: UILabel!
    
    @IBOutlet weak var meetingText: UITextView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let hView = UIView()
        hView.frame = self.frame
        hView.backgroundColor = UIColor(red: 40/255, green: 125/255, blue: 156/255, alpha: 1)
        
        self.selectedBackgroundView = hView
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
