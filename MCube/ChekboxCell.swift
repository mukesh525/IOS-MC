//
//  ChekboxCell.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ChekboxCell: UITableViewCell {

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkbox: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
