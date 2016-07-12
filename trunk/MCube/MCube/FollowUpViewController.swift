
//followup
//track
//lead
//x
//ivrs
//mtracker
//


//  Created by Mukesh Jha on 03/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//



import UIKit
import Alamofire
import AVFoundation



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
    var type:String="track"
    var isNewDataLoading:Bool=false;
    var player = AVPlayer()
    var CurrentTitle:String="Track"
    var isLogout:Bool=false;
    
    
    @IBAction func LogoutTap(sender: UIBarButtonItem) {
        
        LogoutAlert()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isLogout){
         isLogout=false;
         LogoutAlert()
        }
        
         
        self.navigationItem.title = CurrentTitle;
        //        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "select")
        //        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.allowsSelection = false;
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        if let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey") {
            print(authkey)
            LoadData(false)
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
        LoadData(false);
        
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
        cell.callername.text=(data.callerName?.isEmpty) != nil && NSString(string: data.callerName!).length > 0 ?  data.callerName : "UNKNOWN"
        
        if((data.callTimeString?.isEmpty) != nil && NSString(string: data.callTimeString!).length > 0){
            cell.date.text=self.convertDate(data.callTimeString!)
            cell.time.text=self.convertTime(data.callTimeString!)
            cell.status.text=(data.status?.isEmpty) != nil && NSString(string: data.status!).length > 0 ?  data.status : "UNKNOWN"
            cell.Group.text=data.groupName
            cell.groupLabel.text="Group"
            
        }
        else
        {
            cell.date.text=self.convertDate(data.startTime!)
            cell.time.text=self.convertTime(data.startTime!)
            if((data.status?.isEmpty) != nil && NSString(string: data.status!).length > 0){
                cell.status.text=data.status == "0" ? "MISSED": data.status == "1" ? "INBOUND" : "OUTBOND"
            }
            cell.Group.text=data.empName
            cell.groupLabel.text="Employee"
        }
        let image = UIImage(named: "play")?.imageWithRenderingMode(.AlwaysTemplate)
        cell.playButton.setImage(image, forState: .Normal)
        cell.playButton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
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
    
    
    
    func LoadData(filter:Bool){
        var callId:String?
        var callFrom:String?
        var callerName:String?
        var groupName:String?
        var status:String?
        var dataId:String?
        var audioLink:String?
        var callTimeString:String?
        var empName:String?
        limit=0
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey")
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/getList", parameters:
            ["authKey":authkey!, "limit":"10","gid": gid,"ofset":limit,"type":type])
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
                        else if((record.objectForKey("starttime")) != nil){
                            callTimeString=record.objectForKey("starttime") as? String
                            data.startTime=callTimeString;
                            
                        }
                        
                        if((record.objectForKey("empName")) != nil){
                            empName=record.objectForKey("empName") as? String
                            data.empName=empName;
                            
                        }
                        if((record.objectForKey("name")) != nil){
                            callerName=record.objectForKey("name") as? String
                            data.callerName=callerName;
                            
                        }
                        

                        
                        
                        if((record.objectForKey("filename")) != nil){
                            audioLink=record.objectForKey("filename") as? String
                            data.audioLink=audioLink;
                        }
                        
                        self.result.addObject(data)
                    }
                    
                    
                    
                }
                
                if(self.result.count == 0 && filter){
                    self.filteralert()
                }
                else{
                    self.mytableview.reloadData()
                }
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
        var EmpName:String?
        self.limit += 10
        
        
        let authkey = NSUserDefaults.standardUserDefaults().stringForKey("authkey")
        Alamofire.request(.POST, "https://mcube.vmc.in/mobapp/getList", parameters:
            ["authKey":authkey!, "limit":"10","gid": gid,"ofset":self.limit,"type":type])
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
                        else if((record.objectForKey("starttime")) != nil){
                            callTimeString=record.objectForKey("starttime") as? String
                            data.startTime=callTimeString;
                            
                        }
                        if((record.objectForKey("empname")) != nil){
                            EmpName=record.objectForKey("empname") as? String
                            data.empName=EmpName;
                            
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
        LoadData(true);
        
    }
    
    func filteralert (){
        let option: OptionsData = self.options[SeletedFilterpos];
        let alertController = UIAlertController(title: "MCube", message:
            "No Records available for Group : \(option.value!)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.SeletedFilterpos=0;
            self.gid="0";
            self.LoadData(false)
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func LogoutAlert (){
                let alertController = UIAlertController(title: "Logout Alert", message:
            "Do you want to logout?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("authkey")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.performSegueWithIdentifier("GoLogin", sender: self)  
           
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
    
}
