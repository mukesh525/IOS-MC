//
//  FollowupTableViewCell.swift
//  MCube
//
//  Created by Mukesh Jha on 03/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class FollowupTableViewCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBAction func playClicked(sender: AnyObject) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    @IBAction func overflowClicked(sender: AnyObject) {
        
        if let onMoreTapped = self.onMoreTapped {
            onMoreTapped(sender)
        }
    }

    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var callfrom: UILabel!
    @IBOutlet weak var callername: UILabel!
    @IBOutlet weak var Group: UILabel!
    var onButtonTapped : (() -> Void)? = nil
    var onMoreTapped :((AnyObject) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
