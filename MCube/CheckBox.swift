//
//  CheckBox.swift
//  MCube
//
//  Created by Mukesh Jha on 12/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checked")! as UIImage
    let uncheckedImage = UIImage(named: "check")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
