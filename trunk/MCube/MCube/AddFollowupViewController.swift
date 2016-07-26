//
//  AddFollowupViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 22/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class AddFollowupViewController: UIViewController,CustomCellDelegate,UITextFieldDelegate  {
    var currentData:Data!
    var authkey:String?
    var optionsList = [OptionsData]()
    var OptionStringList=[String]()
    var DetailDataList = [DetailData]()
    var ContactNo :String?
    var EmailId :String?
    @IBOutlet weak var mytableView: UITableView!
    private var showingActivity = false
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(DetailViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.mytableView?.addSubview(refreshControl)
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        
        loadDetaildata();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitClick(sender: UIButton) {
        
        
        
    }
    
    
    
    func loadDetaildata() {
        
        if !self.refreshControl.refreshing{
            self.showActivityIndicator()
        }
        
        Alamofire.request(.POST, "https://mcube.vmc.in//mobapp/followupFrm",
            parameters: ["authKey":authkey!]).validate().responseJSON
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
                        // print(detailData.Type!)
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
                                    let newString = detailData.value!.stringByReplacingOccurrencesOfString("\"", withString: "")
                                    let toArray = newString.componentsSeparatedByString(",")
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
                    
                    self.mytableView.reloadData()
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
    
    func showAlert(mesage :String){
        //dismissViewControllerAnimated(true, completion: nil)
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.Center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        loadDetaildata();
    }
    
    
    //MARK: - Tableview Delegate & Datasource
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
            //tableView.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
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
        
        
        if(detaildata.Type == "label")
        {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL1", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
            
        }
            
        else if(detaildata.Type == "hidden")
        {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL1", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            
            return UITableViewCell()
            
        }
            
        else if (detaildata.Type=="text" || detaildata.Type=="textarea") {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("LT1", forIndexPath: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            if (NSString(string: detaildata.value!).length > 1){
                cell3.textfiled.text=detaildata.value}
            cell3.delegate=self
            cell3.textfiled.placeholder = detaildata.label!
            cell3.textfiled.delegate=self
            //   cell3.onEditingBegin = {(selectedRow) -> Void in   }
            
            return cell3
            
            
        }
            
        else if (detaildata.Type=="dropdown" || detaildata.Type=="radio") {
            let cell2 = tableView.dequeueReusableCellWithIdentifier("LP1", forIndexPath: indexPath) as!CustomeCell2
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
           
                
            }
            return cell2
            
        }
            
        else if (detaildata.Type == "checkbox"){
            let cell4 = tableView.dequeueReusableCellWithIdentifier("Ltabel1", forIndexPath: indexPath) as!CustomeCell4
            cell4.label1.text=detaildata.label
            cell4.optionsList=detaildata.OptionList
            cell4.chekboxTable.reloadData()
            
            return cell4
            
        }
        else if (detaildata.Type == "datetime"){
            let cell5 = tableView.dequeueReusableCellWithIdentifier("LD1", forIndexPath: indexPath) as!CustomeCell5
            cell5.label.text = detaildata.label
            detaildata.value=cell5.dateTimePicker.getStringValue();
            cell5.onDateChnaged = { (selectedRow) -> Void in
                detaildata.value=cell5.dateTimePicker.getStringValue();
            }
            return cell5
            
        }
            
        else {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LL1", forIndexPath: indexPath) as!CustomeCell1
            cell1.label1.text=detaildata.label
            cell1.label2.text=detaildata.value
            return cell1
        }
        
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
        else if (detaildata.Type == "datetime"){
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
        let indexPath = self.mytableView.indexPathForRowAtPoint(cell.center)!
        let detaildata: DetailData = self.DetailDataList[indexPath.row]
        detaildata.value=cell.textfiled.text!
        print("index \(indexPath.row)  value  \(cell.textfiled.text!)")
    }
    
    
    
    
}
