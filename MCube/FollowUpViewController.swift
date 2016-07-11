//mukesh
//  FollowUpViewController.swift
//  MCube
//
//  Created by Mukesh Jha on 03/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AZDropdownMenu


class FollowUpViewController: UITableViewController,UIPopoverPresentationControllerDelegate,FilterSelectedDelegate {
    
   

    @IBOutlet var mytableview: UITableView!
    @IBOutlet var extraButton: UIBarButtonItem!
    @IBOutlet var menubutton: UIBarButtonItem!
    let cellSpacingHeight: CGFloat = 5
    var result:NSMutableArray=NSMutableArray();
    var SeletedFilterpos: Int=0;
    //var options:NSMutableArray=NSMutableArray();
    var options = [OptionsData]()
    var limit = 0;
    var gid:String="0";
    var isNewDataLoading:Bool=false;
    var player = AVPlayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false;
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        if let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey") {
            print(authkey)
            LoadData()
        }
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
      
        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
           // extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        LoadData();
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    // Make the background color show through
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return result.count
    }
    
   override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return cellSpacingHeight
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as!FollowupTableViewCell
          let data: Data = self.result[indexPath.row] as! Data
          cell.layer.cornerRadius=15
          cell.layer.borderColor = UIColor.orangeColor().CGColor
          cell.layer.borderWidth = 2
        
          cell.onButtonTapped = {
            if((data.audioLink?.isEmpty) != nil && NSString(string: data.audioLink!).length > 5){
            self.configurePlay(data.audioLink!)
            }else{
            self.showAlert("You clicked Play button \(indexPath.row)")
            }
            
        }
         cell.backgroundColor = UIColor.clearColor()
         if((data.audioLink?.isEmpty) != nil && NSString(string: data.audioLink!).length > 5){
           cell.playButton.hidden=false
         }else{
           cell.playButton.hidden=true
         }
        
         cell.callfrom.text=data.callFrom
         cell.callername.text=data.callerName
         cell.Group.text=data.groupName
         cell.date.text=self.convertDate(data.callTimeString!)
         cell.time.text=self.convertTime(data.callTimeString!)
         cell.status.text=data.status
         return cell
    }
    
    
    
    
    func configurePlay(filename:String) {
        let url = "http://mcube.vmctechnologies.com/sounds/\(filename)"
        let playerItem = AVPlayerItem( URL:NSURL( string:url )! )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
        
    }
    
    
    
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 153;
    }
    
   override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                     isNewDataLoading = true
                        LoadMoreData()
                    
                }
            }
        }
    }
    
   
    
    func LoadData(){
        var callId:String?
        var callFrom:String?
        var callerName:String?
        var groupName:String?
        var status:String?
        var dataId:String?
        var audioLink:String?
        var callTimeString:String?
         limit=0
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey")
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/getList", parameters:
        ["authKey":authkey!, "limit":"10","gid": gid,"ofset":limit,"type":"track"])
        .validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
               
                self.result=NSMutableArray();
               // self.options=NSMutableArray();
                self.options=[OptionsData]();
                let response = JSON as! NSDictionary
                
                if(response.objectForKey("groups") != nil){
                    let groups = response.objectForKey("groups") as! NSArray?
                    for group in groups!{
                        let options=OptionsData();
                        if((group.objectForKey("key")) != nil){
                            options.id=group.objectForKey("key") as? String
                        }
                        if((group.objectForKey("val")) != nil){
                            options.value=group.objectForKey("val") as? String
                        }
                        self.options.append(options)
                    }
                    
                    
                    
                }
                if(response.objectForKey("records") != nil){
                let records = response.objectForKey("records") as! NSArray?
                      for record in records!{
                        let data=Data();
                        if((record.objectForKey("callid")) != nil){
                            callId=record.objectForKey("callid") as? String
                            data.callId=callId;
                         }
                        if((record.objectForKey("callfrom")) != nil){
                            callFrom=record.objectForKey("callfrom") as? String
                            data.callFrom=callFrom;
                        }

                        if((record.objectForKey("callid")) != nil){
                            callId=record.objectForKey("callid") as? String
                            data.callId=callId;
                        }
                        if((record.objectForKey("status")) != nil){
                            status=record.objectForKey("status") as? String
                            data.status=status;
                        }
                        if((record.objectForKey("callername")) != nil){
                            callerName=record.objectForKey("callername") as? String
                            data.callerName=callerName;
                        }
                        if((record.objectForKey("groupname")) != nil){
                            groupName=record.objectForKey("groupname") as? String
                            data.groupName=groupName;
                        }
                        if((record.objectForKey("calltime")) != nil){
                            callTimeString=record.objectForKey("calltime") as? String
                            data.callTimeString=callTimeString;
                            data.callTime=self.convertDateFormater(callTimeString!) as? NSDate
                        }
                        if((record.objectForKey("filename")) != nil){
                            audioLink=record.objectForKey("filename") as? String
                            data.audioLink=audioLink;
                        }
                       
                        self.result.addObject(data)
                     }
                    
                 
                
                }
                
                
            self.mytableview.reloadData()
                if((self.refreshControl?.beginRefreshing()) != nil){
                   self.refreshControl!.endRefreshing()
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                if (error.code == -1009) {
                    self.showAlert("No Internet Conncetion")
                }
                
                
                }
                
                
                print("result sidze \(self.result.count))")
//                if(self.code=="401"||self.code=="400"){
//                    if(self.message != nil){
//                        self.showAlert(self.message!)
//                    }
//                }
//                if(self.code=="200"){
//                    if(self.message != nil){
//                        NSUserDefaults.standardUserDefaults().setObject(self.empName, forKey: "name")
//                        NSUserDefaults.standardUserDefaults().setObject(self.empEmail, forKey: "email")
//                        NSUserDefaults.standardUserDefaults().setObject(self.authkey, forKey: "authkey")
//                        NSUserDefaults.standardUserDefaults().synchronize()
//                        if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("name") {
//                            print(myLoadedString) // "Hello World"
//                        }
//                        self.performSegueWithIdentifier("Login", sender: nil)
//                        //self.showAlert(self.message!)
//                    }
                }
                
        }
    
    func LoadMoreData(){
        var callId:String?
        var callFrom:String?
        var callerName:String?
        var groupName:String?
        var status:String?
        var dataId:String?
        var audioLink:String?
        var callTimeString:String?
        self.limit += 10
        
        
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey")
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/getList", parameters:
            ["authKey":authkey!, "limit":"10","gid": gid,"ofset":self.limit,"type":"track"])
            .validate().responseJSON
            {response in switch response.result {
                
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                //self.result=NSMutableArray();
                let response = JSON as! NSDictionary
                if(response.objectForKey("records") != nil){
                    let records = response.objectForKey("records") as! NSArray?
                    for record in records!{
                        let data=Data();
                        if((record.objectForKey("callid")) != nil){
                            callId=record.objectForKey("callid") as? String
                            data.callId=callId;
                        }
                        if((record.objectForKey("callfrom")) != nil){
                            callFrom=record.objectForKey("callfrom") as? String
                            data.callFrom=callFrom;
                        }
                        if((record.objectForKey("callid")) != nil){
                            callId=record.objectForKey("callid") as? String
                            data.callId=callId;
                        }
                        if((record.objectForKey("status")) != nil){
                            status=record.objectForKey("status") as? String
                            data.status=status;
                        }
                        if((record.objectForKey("callername")) != nil){
                            callerName=record.objectForKey("callername") as? String
                            data.callerName=callerName;
                        }
                        if((record.objectForKey("groupname")) != nil){
                            groupName=record.objectForKey("groupname") as? String
                            data.groupName=groupName;
                        }
                        if((record.objectForKey("calltime")) != nil){
                            callTimeString=record.objectForKey("calltime") as? String
                            data.callTimeString=callTimeString;
                            data.callTime=self.convertDateFormater(callTimeString!)as?NSDate
                        }
                        if((record.objectForKey("filename")) != nil){
                            audioLink=record.objectForKey("filename") as? String
                            data.audioLink=audioLink;
                        }
                        
                        self.result.addObject(data)
                        
                    }
                    
                }
                
                
                self.mytableview.reloadData()
                self.isNewDataLoading=false;
                if((self.refreshControl?.beginRefreshing()) != nil){
                    self.refreshControl!.endRefreshing()
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                if (error.code == -1009) {
                    self.showAlert("No Internet Conncetion")
                }
                
                
                }
                
                
                print("result sidze \(self.result.count))")
                //                if(self.code=="401"||self.code=="400"){
                //                    if(self.message != nil){
                //                        self.showAlert(self.message!)
                //                    }
                //                }
                //                if(self.code=="200"){
                //                    if(self.message != nil){
                //                        NSUserDefaults.standardUserDefaults().setObject(self.empName, forKey: "name")
                //                        NSUserDefaults.standardUserDefaults().setObject(self.empEmail, forKey: "email")
                //                        NSUserDefaults.standardUserDefaults().setObject(self.authkey, forKey: "authkey")
                //                        NSUserDefaults.standardUserDefaults().synchronize()
                //                        if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("name") {
                //                            print(myLoadedString) // "Hello World"
                //                        }
                //                        self.performSegueWithIdentifier("Login", sender: nil)
                //                        //self.showAlert(self.message!)
                //                    }
        }
        
    }

    
    
  
        
        func showAlert(mesage :String){
            //dismissViewControllerAnimated(true, completion: nil)
            let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    
    
    func convertDateFormater(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date)
        
        return timeStamp
    }
    
    func convertDate(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date)
        
        return timeStamp
    }
    func convertTime(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "HH:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date)
        
        return timeStamp
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" && options.count > 0{
            
            let popoverViewController = segue.destinationViewController as! menuViewController
            popoverViewController.FilterOptions=options;
            popoverViewController.SeletedFilter=SeletedFilterpos;
           // popoverViewController.preferredContentSize = CGSize(width: 150, height: 400)
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
        }
  
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func filterSelected(position: Int) {
        self.SeletedFilterpos=position;
        let option: OptionsData = self.options[position]
        self.gid=option.id!;
        LoadData();
        
    }
    
    
    
    
    
    

}
