//
//  DetailViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,CustomCellDelegate,UITextFieldDelegate {

    var DetailDataList = [DetailData]()
    var optionsList = [OptionsData]()
    var OptionStringList=[String]()
    var currentData:Data!
    private var showingActivity = false
    var authkey:String?
    var type:String?
    var ContactNo :String?
    var EmailId :String?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var mytableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey") {
            self.authkey=authkey;
        }
        mytableview.delegate = self
        mytableview.dataSource = self
        mytableview.allowsSelection=false
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        loadDetaildata();
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.mytableview?.addSubview(refreshControl)
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -170
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
      loadDetaildata(); 
    }

    
    @IBAction func UpdateClick(sender: AnyObject) {
        
       self.UpdateRecords()
        
    }
    
    
    func getParams()->[String: AnyObject]?{
    
        var parameters: [String: AnyObject]? = [:]
        print(self.DetailDataList.count)
        parameters!["authKey"]=self.authkey!
        parameters!["type"]=self.type!
        parameters!["groupname"]=(currentData.groupName != nil ? currentData.groupName : currentData.empName)!

        for curentValue in  self.DetailDataList{
            
            if(curentValue.Type == "checkbox"){
                var val=[String]()
                for option in curentValue.OptionList{
                    if(option.isChecked){
                        val.append(option.id!)
                    }
                }
                
                if(val.count>0){
                    let joined=val.joinWithSeparator(",")
                    print("\(curentValue.Name!)  :   \(joined)")
                    parameters![curentValue.Name!] = joined
                    
                }else{
                    print("\(curentValue.Name!)  :  null")
                    
                    parameters![curentValue.Name!] = "null"
                    
                    
                }
                
            }else if(curentValue.Type == "dropdown"){
                print("\(curentValue.Name!)  :   \(curentValue.value!)")
                parameters![curentValue.Name!] = curentValue.value!
            } else {
                print("\(curentValue.Name!)  :   \(curentValue.value!)")
                parameters![curentValue.Name!] = curentValue.value!
            }
            
        }
        print(parameters!.keys.count) // 0
        
        return parameters
   
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return DetailDataList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let detaildata: DetailData = self.DetailDataList[indexPath.row] 
        
       
          if(detaildata.Type == "label")
        {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        
        }
        
        else if(detaildata.Type == "hidden")
          {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            
            return UITableViewCell()
            
        }
        
        else if (detaildata.Type=="text") {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("LT", forIndexPath: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            cell3.textfiled.text=detaildata.value
            cell3.delegate=self
            cell3.textfiled.delegate=self

            return cell3
            
            
        }
        
        else if (detaildata.Type=="textarea") {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("LT", forIndexPath: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            cell3.textfiled.text=detaildata.value
            cell3.delegate=self
            cell3.onEditingBegin = {[unowned self] (selectedRow) -> Void in
                var pointInTable:CGPoint = selectedRow.textfiled.superview!.convertPoint(selectedRow.textfiled.frame.origin, toView:tableView)
                var contentOffset:CGPoint = tableView.contentOffset
                contentOffset.y  = pointInTable.y
                if let accessoryView = selectedRow.textfiled.inputAccessoryView {
                    contentOffset.y -= accessoryView.frame.size.height
                }
                tableView.contentOffset = contentOffset
            }
            return cell3
            
            
        }
        else if (detaildata.Type=="dropdown" || detaildata.Type=="radio") {
            let cell2 = tableView.dequeueReusableCellWithIdentifier("LP", forIndexPath: indexPath) as!CustomeCell2
             cell2.label.text=detaildata.label
             cell2.Options=detaildata.Options
             cell2.itemAtDefaultPosition=detaildata.value!
             cell2.pickerSelected = { [unowned self] (selectedRow) -> Void in
                detaildata.value=detaildata.OptionList[selectedRow].id
                print("the selected item is \(selectedRow)")
                print("the selected value is \(detaildata.Options[selectedRow])")
                
            }

            return cell2
            
        }
        
       else if (detaildata.Type == "checkbox"){
       let cell4 = tableView.dequeueReusableCellWithIdentifier("Ltabel", forIndexPath: indexPath) as!CustomeCell4
           cell4.label1.text=detaildata.label
           cell4.optionsList=detaildata.OptionList
           cell4.chekboxTable.reloadData()
            
          return cell4
            
       }
        //if (detaildata.label != nil && detaildata.label != "")
        else {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let detaildata: DetailData = self.DetailDataList[indexPath.row]
        let count=CGFloat(detaildata.OptionList.count);
        let chekheight=CGFloat(44);
        if(detaildata.Type == "hidden"){
         return 0
        }
        else if (detaildata.Type=="dropdown" || detaildata.Type=="radio") {
        
        return 100
        }
        else if (detaildata.Type == "checkbox"){
            return chekheight * count
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


    
     
    func loadDetaildata() {
        
        if !self.refreshControl.refreshing{
            self.showActivityIndicator()
        }
      
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/getDetail",
            parameters: ["authKey":self.authkey!,"type":self.type!, "callid":currentData.callId!, "groupname":(currentData.groupName != nil ? currentData.groupName : currentData.empName)!]).validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                
                 //self.showActivityIndicator()
                if((response.objectForKey("fields")) != nil){
                    self.DetailDataList=[DetailData]()
                    let fields = response.objectForKey("fields") as! NSArray?
                    
                    for field in fields!{
                        let detailData=DetailData();
                        if((field.objectForKey("name")) != nil){
                            detailData.Name=field.objectForKey("name") as? String
                            
                        }
                        if((field.objectForKey("label")) != nil){
                            detailData.label=field.objectForKey("label") as? String
                            
                        }
                        
                        if((field.objectForKey("type")) != nil){
                            detailData.Type=field.objectForKey("type") as? String
                           
                        }
                        if((field.objectForKey("value")) != nil){
                            detailData.value=field.objectForKey("value") as? String
                            
                        }
                        
                        let optionsLabel = ["dropdown", "radio","checkbox"]
                        print(detailData.Type!)
                        let contained = optionsLabel.contains(detailData.Type!)
                        if(contained){
                            let Options = field.objectForKey("options") as! NSDictionary?
                            self.optionsList=[OptionsData]()
                            self.OptionStringList=[String]()
                            print("Data items count: \(Options!.count)")
                            for (key, value) in Options! {
                                 let mOptionsData = OptionsData();
                                 mOptionsData.id=key as? String
                                 mOptionsData.value=value as? String
                                 if(key as? String == detailData.value){
                                    detailData.value=value as? String
                                  }
                                
                                if (detailData.Type!.containsString("checkbox") && !detailData.value!.containsString("")) {
                                 //   value = "check1,check3";
                                    let newString = detailData.value!.stringByReplacingOccurrencesOfString("\"", withString: "")
                                    let toArray = newString.componentsSeparatedByString(",")
                                    print(newString)
                                    for curentValue in toArray  {
                                        if (key as! String==curentValue) {
                                            mOptionsData.isChecked=true
                                            print(" \(curentValue) is cheked")
                                        }
                                       print(curentValue)
                                    }
                                  }
                                
                                
                                self.OptionStringList.append(value as! String)
                                self.optionsList.append(mOptionsData)
                                //print("Property: \"\(key as! String)\"")
                            }
                               detailData.OptionList=self.optionsList;
                            
                       
                        }
                        else {
                            self.optionsList=[OptionsData]()
                            self.OptionStringList=[String]()

                        }
                        
                        detailData.OptionList=self.optionsList
                        detailData.Options=self.OptionStringList
                        
                        if (detailData.Name == "callfrom") {
                            self.ContactNo = detailData.value;
                        } else if (detailData.Name == "callfrom") {
                            self.EmailId = detailData.value;
                        }
                        
                       self.DetailDataList.append(detailData);


                }
                    if self.refreshControl.refreshing{
                        self.refreshControl.endRefreshing()
                    }
                    else{
                        self.showActivityIndicator()
                    }

                    self.mytableview.reloadData()
                    print(self.DetailDataList.count)
                    
            }
                
            
            
                case .Failure(let error):
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
 }

    }
    
    func UpdateRecords() {
        var code:String?
        var msg:String?
        self.showActivityIndicator()
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/postDetail",
            parameters: self.getParams()).validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                if((response.objectForKey("code")) != nil){
                   code=response.objectForKey("code") as? String
                    
                }
                if((response.objectForKey("msg")) != nil){
                    msg=response.objectForKey("msg") as? String
                    
                }
                
                self.showActivityIndicator()
                if(code == "202" && msg != nil){
                self.showAlert("Records Updates Successfully")
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
    
   
    func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.Center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    
    
   
    
    func showAlert(mesage :String){
        //dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    



}
