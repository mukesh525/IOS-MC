//
//  CustomeCell2.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CustomeCell2: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var uiPicker: UIPickerView!
    var pickerSelected: ((Int) -> Void)?

   // var data = ["cat", "bird", "frog"]
    var Options = [String]()
    var itemAtDefaultPosition: String="" //Set through another ViewController
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uiPicker.dataSource = self
        self.uiPicker.delegate = self
        
        
        
        
        
     }
    override func layoutSubviews() {
        super.layoutSubviews()
        uiPicker.reloadAllComponents()
        var defaultRowIndex = Options.indexOf(itemAtDefaultPosition)
        if(defaultRowIndex == nil) { defaultRowIndex = 0 }
        uiPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
        
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
       // var selectedValue = pickerViewContent[pickerView.selectedRowInComponent(0)]
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        pickerSelected?(row)
     //   print("selected uipickervalue \(Options[row])")
       // print("selected uipickervalue \(selectedValue!)")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        // Column count: use one column.
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // Row count: rows equals array length.
        return Options.count
    }
    
    func pickerView(pickerView: UIPickerView,
                    titleForRow row: Int,
                                forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        return Options[row]
    }
    
    

}
