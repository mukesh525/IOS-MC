//
//  DetailViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController,UITableViewDataSource,UIPopoverPresentationControllerDelegate, UITableViewDelegate,CustomCellDelegate,UITextFieldDelegate ,DetailDownload{

    @IBOutlet weak var updatebtn: UIButton!
    @IBOutlet weak var addfollowup: UIButton!
    var DetailDataList = Array<DetailData>();
    var optionsList = Array<OptionsData>();
    var OptionStringList=[String]()
    var currentData:Data!
    var showingActivity = false
    var authkey:String?
    var type:String?
    var ContactNo :String?
    var EmailId :String?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var mytableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews();
        
        if !self.refreshControl.refreshing{
            self.showActivityIndicator()
        }
        DetailDataTask(delegate: self).loadDetaildata(authkey!, type: self.type!, currentData:currentData);

        
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func refresh(sender:AnyObject) {
      DetailDataTask(delegate: self).loadDetaildata(authkey!, type: self.type!, currentData:currentData);
    }
    
    
    func OnError(error: NSError) {
        print("Request failed with error: \(error)")
        if (error.code == -1009) {
           self.showAlert("No Internet Conncetion")
        }
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        else{
            self.showActivityIndicator()
        }
    }
    
    
    func OnFinishDownload(result: Array<DetailData>) {
     
        self.DetailDataList=result;
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        else{
            self.showActivityIndicator()
        }
        
        self.mytableview.reloadData()
        print(self.DetailDataList.count)
        
        
        
    }
    
     @IBAction func UpdateClick(sender: AnyObject) {
        
       self.UpdateRecords()
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if DetailDataList.count == 0{
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "No Data Pull Down To Refresh"
            emptyLabel.textAlignment = NSTextAlignment.Center
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else {
            tableView.backgroundView=UIView()
            tableView.backgroundView?.backgroundColor = UIColor.clearColor()
            return DetailDataList.count
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let detaildata: DetailData = self.DetailDataList[indexPath.row] 
        
       
          if(detaildata.Type == LABEL)
        {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        
        }
        
        else if(detaildata.Type == HIDDEN)
          {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            
            return UITableViewCell()
            
        }
        
        else if (detaildata.Type==TEXT || detaildata.Type==TEXTAREA) {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("LT", forIndexPath: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            if (NSString(string: detaildata.value!).length > 1){
            cell3.textfiled.text=detaildata.value}
            cell3.delegate=self
            cell3.textfiled.placeholder = detaildata.label!
            cell3.textfiled.delegate=self
     

            return cell3
            
            
        }
        
        else if (detaildata.Type==DROPDOWN || detaildata.Type==RADIO) {
            let cell2 = tableView.dequeueReusableCellWithIdentifier("LP", forIndexPath: indexPath) as!CustomeCell2
             cell2.label.text=detaildata.label
             cell2.Options=detaildata.Options
            if (NSString(string: detaildata.value!).length > 1){
                cell2.itemAtDefaultPosition=detaildata.value!}
            else{
                cell2.itemAtDefaultPosition = detaildata.OptionList[0].value!
                detaildata.value=detaildata.OptionList[0].id!
             }
             cell2.pickerSelected = { (selectedRow) -> Void in
                detaildata.value=detaildata.OptionList[selectedRow].id
                print("the selected item is \(selectedRow)")
                print("the selected value is \(detaildata.Options[selectedRow])")
                
            }

            return cell2
            
        }
        else if (detaildata.Type == DATE_TIME){
            let cell5 = tableView.dequeueReusableCellWithIdentifier("LD", forIndexPath: indexPath) as!CustomeCell5
            cell5.label.text = detaildata.label
            detaildata.value=cell5.dateTimePicker.getStringValue();
            cell5.onDateChnaged = { (selectedRow) -> Void in
                detaildata.value=cell5.dateTimePicker.getStringValue();
            }
            return cell5
            
          }

        
       else if (detaildata.Type == CHECKBOX){
       let cell4 = tableView.dequeueReusableCellWithIdentifier("Ltabel", forIndexPath: indexPath) as!CustomeCell4
           cell4.label1.text=detaildata.label
           cell4.optionsList=detaildata.OptionList
           cell4.chekboxTable.reloadData()
            
          return cell4
            
       }
        else {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        }

    }
    
 
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let detaildata: DetailData = self.DetailDataList[indexPath.row]
        let count=CGFloat(detaildata.OptionList.count);
        let chekheight=CGFloat(44);
        if(detaildata.Type == HIDDEN){
         return 0
        }
        else if (detaildata.Type==DROPDOWN || detaildata.Type==RADIO) {
        
        return 100
        }
        else if (detaildata.Type == CHECKBOX){
            return chekheight * count
        }
        else if (detaildata.Type == DATE_TIME){
            return 150
        }
        else{
            return 44
        
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func cellTextChanged(cell: CustomeCell3) {
        let indexPath = self.mytableview.indexPathForRowAtPoint(cell.center)!
        let detaildata: DetailData = self.DetailDataList[indexPath.row]
        detaildata.value=cell.textfiled.text!
        print("index \(indexPath.row)  value  \(cell.textfiled.text!)")
    }


    func UpdateRecords() {
        var code:String?
        var msg:String?
        self.showActivityIndicator()
        Alamofire.request(.POST, POST_DETAIL,
            parameters: self.DetailDataList.getParams(self.currentData,type:self.type!,postFollowup: false)).validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                if((response.objectForKey(CODE)) != nil){
                   code=response.objectForKey(CODE) as? String
                    
                }
                if((response.objectForKey(MESSAGE)) != nil){
                    msg=response.objectForKey(MESSAGE) as? String
                    
                }
                
                self.showActivityIndicator()
                if(code == "202" && msg != nil){
                self.showAlert("Records Updated Successfully")
                }else{
                self.showAlert("Something went wrong try again")
                 }
            case .Failure(let error):
                print("Request failed with error: \(error)")
                self.showActivityIndicator()
                if (error.code == -1009) {
                    self.showAlert("No Internet Conncetion")
                }
               }
        }
    }
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ADD_FOLLOWUP{
            let addfollowup = segue.destinationViewController as! AddFollowupController
            addfollowup.currentData=self.currentData;
            addfollowup.authkey=self.authkey;
            addfollowup.type=self.type;
           
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
