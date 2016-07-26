//
//  CustomeCell5.swift
//  MCube
//
//  Created by Mukesh Jha on 24/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CustomeCell5: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    var onDateChnaged :((CustomeCell5) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ValueChanged(sender: UIDatePicker) {
         onDateChnaged?(self)     
    }
}
