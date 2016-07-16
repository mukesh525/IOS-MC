//
//  DetailViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 15/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var DetailDataList = [DetailData]()
    var optionsList = [OptionsData]()
    var OptionStringList=[String]()
    var currentData:Data!
    private var showingActivity = false
    var authkey:String?
    var type:String?
    var ContactNo :String?
    var EmailId :String?
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var mytableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey") {
            self.authkey=authkey;
        }
        mytableview.delegate = self
        mytableview.dataSource = self
        mytableview.allowsSelection=false
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        loadDetaildata();
    }

    
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
      loadDetaildata(); 
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
            
            return cell3
            
            
        }
        
        else if (detaildata.Type=="textarea") {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("LT", forIndexPath: indexPath) as!CustomeCell3
            cell3.label1.text=detaildata.label
            cell3.textfiled.text=detaildata.value
            
            return cell3
            
            
        }
        else if (detaildata.Type=="dropdown" || detaildata.Type=="radio") {
            let cell2 = tableView.dequeueReusableCellWithIdentifier("LP", forIndexPath: indexPath) as!CustomeCell2
             cell2.label.text=detaildata.label
             cell2.Options=detaildata.Options
             cell2.itemAtDefaultPosition=detaildata.value!
             return cell2
            
            
        }
        
       else if (detaildata.Type == "checkbox"){
       let cell4 = tableView.dequeueReusableCellWithIdentifier("Ltabel", forIndexPath: indexPath) as!CustomeCell4
           cell4.label1.text=detaildata.label
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
        if(detaildata.Type == "hidden"){
        
            return 0
        }
        else if (detaildata.Type=="dropdown" || detaildata.Type=="radio") {
        
        return 100
        }
        else if (detaildata.Type == "checkbox"){
            return 88
        }
        else{
            return 44
        
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
    func loadDetaildata() {
        self.showActivityIndicator()
        Alamofire.request(.POST, "https://mcube.vmc.in//mobapp/getDetail",
            parameters: ["authKey":self.authkey!,"type":self.type!, "callid": (currentData?.callId)!, "groupname":(currentData?.groupName)!]).validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                
                 self.showActivityIndicator()
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
                    
                   self.mytableview.reloadData()
                    print(self.DetailDataList.count)
                    
            }
                
            
            
                case .Failure(let error):
                print("Request failed with error: \(error)")
                if (error.code == -1009) {
                    self.showAlert("No Internet Conncetion")
                }
                
                self.showActivityIndicator()
                }
//                if(self.code=="401"||self.code=="400"){
//                    if(self.message != nil){
//                        self.showActivityIndicator()
//                        self.showAlert(self.message!)
//                    }
//                }
//                if(self.code=="200"){
//                    if(self.message != nil){
//                        self.showActivityIndicator()
//                        NSUserDefaults.standardUserDefaults().setObject(self.empName, forKey: "name")
//                        NSUserDefaults.standardUserDefaults().setObject(self.empEmail, forKey: "email")
//                        NSUserDefaults.standardUserDefaults().setObject(self.authkey, forKey: "authkey")
//                        NSUserDefaults.standardUserDefaults().setObject(self.empContact, forKey: "empContact")
//                        NSUserDefaults.standardUserDefaults().setObject(self.businessName, forKey: "businessName")
//                        // NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "select")
//                        NSUserDefaults.standardUserDefaults().synchronize()
//                        if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("name") {
//                            print(myLoadedString) // "Hello World"
//                        }
//                        
//                        if(self.rememberMe){
//                            NSUserDefaults.standardUserDefaults().setObject(self.email.text, forKey: "emailfield")
//                            NSUserDefaults.standardUserDefaults().setObject(self.password.text, forKey: "passfield")
//                            NSUserDefaults.standardUserDefaults().synchronize()
//                        }
//                        else{
//                            if NSUserDefaults.standardUserDefaults().stringForKey("emailfield") != nil
//                                && NSUserDefaults.standardUserDefaults().stringForKey("passfield") != nil
//                            {
//                                NSUserDefaults.standardUserDefaults().removeObjectForKey("emailfield")
//                                NSUserDefaults.standardUserDefaults().removeObjectForKey("passfield")
//                                NSUserDefaults.standardUserDefaults().synchronize()
//                                
//                            }
//                        }
//                        
//                        
//                        
//                        
//                        self.performSegueWithIdentifier("login", sender: self)
//                        //self.showAlert(self.message!)
//                        
//                        
//                        
//                    }
//                }
//                
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
