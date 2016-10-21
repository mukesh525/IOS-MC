//
//  CustomeCell3.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit


protocol CustomCellDelegate {
    func cellTextChanged(_ cell: CustomeCell3)
}


class CustomeCell3: UITableViewCell{
    var delegate: CustomCellDelegate?
    @IBOutlet weak var textfiled: UITextField!
    @IBOutlet weak var label1: UILabel!
    var tableview:UITableView!
    var onTextChanged :((CustomeCell3) -> Void)?
    var onEditingBegin :((CustomeCell3) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        textfiled.addTarget(self, action: #selector(CustomeCell3.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
           }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidChange(_ textField: UITextField) {
        onTextChanged?(self)
        delegate?.cellTextChanged(self)
     
    }
    @IBAction func textFieldDidBeginEditing(_ sender: AnyObject) {
        onEditingBegin?(self)
      
      //  return true;

    }
   
   

}
