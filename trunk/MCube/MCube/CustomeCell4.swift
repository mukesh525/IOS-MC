//
//  CustomeCell4.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CustomeCell4: UITableViewCell ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var chekboxTable: UITableView!
    @IBOutlet weak var label1: UILabel!
    var optionsList = [OptionsData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chekboxTable.delegate = self
        chekboxTable.dataSource = self
        chekboxTable.allowsSelection=false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return optionsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "checkcell", for: indexPath) as!ChekboxCell
        let optdata: OptionsData = self.optionsList[(indexPath as NSIndexPath).row]
        cell1.checklabel.text=optdata.value
        cell1.Chekbox.on = optdata.isChecked
        cell1.DidTapCheckBox = {(checkbox) -> Void in
        optdata.isChecked=checkbox.on
            
       
        }
        
        return cell1
            
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return 44
    }
    
    
    
    
    


}
