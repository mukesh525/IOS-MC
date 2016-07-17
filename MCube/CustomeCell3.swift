//
//  CustomeCell3.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit


protocol CustomCellDelegate {
    func cellTextChanged(cell: CustomeCell3)
}


class CustomeCell3: UITableViewCell {
    var delegate: CustomCellDelegate?
    @IBOutlet weak var textfiled: UITextField!
    @IBOutlet weak var label1: UILabel!
    var onTextChanged :((CustomeCell3) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textfiled.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
           }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidChange(textField: UITextField) {
        onTextChanged?(self)
        delegate?.cellTextChanged(self)
     
    }
   

}
