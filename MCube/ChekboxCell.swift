//
//  ChekboxCell.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import BEMCheckBox

class ChekboxCell: UITableViewCell ,BEMCheckBoxDelegate{

    @IBOutlet weak var checklabel: UILabel!
    var DidTapCheckBox: ((BEMCheckBox) -> Void)?
    @IBOutlet weak var Chekbox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func didTapCheckBox(checkBox: BEMCheckBox) {
        DidTapCheckBox?(checkBox)
        
    }
    

}
