//  Created by Mukesh Jha on 03/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//
import UIKit
import Alamofire
import AVFoundation


class FollowUpViewController: UITableViewController,UIPopoverPresentationControllerDelegate,FilterSelectedDelegate ,SWRevealViewControllerDelegate,ReportDownload {
    @IBOutlet var mytableview: UITableView!
    @IBOutlet var extraButton: UIBarButtonItem!
    @IBOutlet var menubutton: UIBarButtonItem!
    let cellSpacingHeight: CGFloat = 5
    var result:NSMutableArray=NSMutableArray();
    var SeletedFilterpos: Int=0;
    var isDownloading:Bool = false;
    var options :Array<OptionsData> = Array<OptionsData>()
    var playButtons=[UIButton]();
    var limit = 10;
    var offset=0;
    var gid:String="0";
    var type:String="track"
    var isNewDataLoading:Bool=false;
    var player:AVPlayer!
    var CurrentTitle:String="Track"
    var isLogout:Bool=false;
    var CurrentData:Data!
    //var mediaPlayer = VLCMediaPlayer()
    private var showingActivity = false
    var CurrentPlaying:Int?
    var refreshControll = UIRefreshControl()
    var sidebarMenuOpen:Bool?
    @IBAction func LogoutTap(sender: UIBarButtonItem) {
        LogoutAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setsection()
        if let savedlimit = NSUserDefaults.standardUserDefaults().stringForKey("limit") {
            self.limit = Int(savedlimit)!;
        }else {self.limit=10}
        if(isLogout){
            isLogout=false;
            LogoutAlert()
        }
        NSUserDefaults.standardUserDefaults().removeObjectForKey("select")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.navigationItem.title = CurrentTitle;
        tableView.allowsSelection = true;
        mytableview.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
        if NSUserDefaults.standardUserDefaults().stringForKey("authkey") != nil {
            result=ModelManager.getInstance().getData(type)
            options=ModelManager.getInstance().getMenuData(type)
            if(result.count>0 && options.count>0){
                self.playButtons=[UIButton]()
                tableView.reloadData()
            }
            else if(!self.isDownloading){
              
                let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
                self.isDownloading=true;
                self.showActivityIndicator()
                Report(param: param, delegate: self).LoadData();
            }
            
        }
        
        self.refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControll.addTarget(self, action: #selector(FollowUpViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.mytableview?.addSubview(refreshControll)
        if revealViewController() != nil {
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        self.revealViewController().delegate = self
        if self.refreshControll.refreshing{
            self.refreshControll.endRefreshing()
        }
        
       
    }
    
    
    func OnFinishDownload(result: NSMutableArray,param:Params) {
       self.isNewDataLoading = false
       if(param.isMore == true){
        self.result.addObjectsFromArray(result as [AnyObject])
        }else{
          self.result=result;
        }
        
        if(self.result.count == 0 && param.isfilter == true){
            self.showActivityIndicator()
            self.filteralert()
        }
        else if(self.result.count == 0 && param.isfilter == false){
            self.showActivityIndicator()
            self.NoDataAlert()
            
        }
        else{
            if self.refreshControll.refreshing{
                self.refreshControll.endRefreshing()
            }
            
            else{
                if(param.isMore==false){
                self.showActivityIndicator()
                }
            }
            self.mytableview.reloadData()
        }
           self.isDownloading=false;
       
        }

    
    
    
    func OnError(error: NSError) {
        self.isDownloading=false;
        self.isNewDataLoading=false;
        if self.refreshControll.refreshing{
            self.refreshControll.endRefreshing()
        }else{
            self.showActivityIndicator()
        }
        print("Request failed with error: \(error)")
        if (error.code == -1009) {
            self.showAlert("No Internet Conncetion")
        }
        else if(error.code == -1001){
            self.showAlert("No Internet Conncetion")
        }
    }
    

   func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        if(!self.isDownloading){
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();

        }
        else{
            if self.refreshControll.refreshing{
                self.refreshControll.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
       self.playButtons=[UIButton]()
        self.tableView.reloadData()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if result.count == 0{
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "No Data Pull Down To Refresh"
            emptyLabel.textAlignment = NSTextAlignment.Center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else {
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
            return result.count
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.CurrentData = self.result[indexPath.row] as! Data
        self.performSegueWithIdentifier("detail", sender: self)
        
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
        cell.playButton.tag=indexPath.row
        cell.onButtonTapped = {
            if((data.audioLink?.isEmpty) != nil && NSString(string: data.audioLink!).length > 5){
                self.configurePlay(data.audioLink!,playbutton: cell.playButton)
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
        cell.callername.text=(data.callerName?.isEmpty) != nil && NSString(string: data.callerName!).length > 1 ?  data.callerName : "UNKNOWN"
        
        if((data.callTimeString?.isEmpty) != nil && NSString(string: data.callTimeString!).length > 1){
            cell.date.text=data.callTimeString!.getDateFromString()
            cell.time.text=data.callTimeString!.getTimeFromString()
            cell.status.text=(data.status?.isEmpty) != nil && NSString(string: data.status!).length > 1 ?  data.status : "UNKNOWN"
            
            cell.Group.text=data.groupName
            cell.groupLabel.text="Group"
            
        }
        else
        {
            cell.date.text=data.startTime!.getDateFromString()
            cell.time.text=data.startTime!.getTimeFromString()
            if((data.status?.isEmpty) != nil && NSString(string: data.status!).length > 0){
                cell.status.text=data.status == "0" ? "MISSED": data.status == "1" ? "INBOUND" : "OUTBOND"
            }
            cell.Group.text=data.empName
            cell.groupLabel.text="Employee"
        }
        
        let image = UIImage(named: "play")?.imageWithRenderingMode(.AlwaysTemplate)
        cell.playButton.setImage(image, forState: .Normal)
        cell.playButton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        if(indexPath.row == 0){
           self.playButtons=[UIButton]()
        }
        self.playButtons.append(cell.playButton)
        
        
        return cell
    }
    
    
    
    
    func configurePlay(filename:String,playbutton:UIButton) {
        
        let url = "http://mcube.vmctechnologies.com/sounds/\(filename)"
        let linkString = "http://m.mp3.zing.vn/xml/song-load/MjAxNSUyRjA4JTJGMDQlMkY3JTJGYiUyRjdiNTI4YTc0YWU2MGExYWJjMDZlYzA5NmE5MzFjMjliLm1wMyU3QzEz"
        let link = NSURL(string: url)!
        
        
        for currentbutton in self.playButtons{
            if(currentbutton.tag == playbutton.tag ){
                var image:UIImage?
                if(self.CurrentPlaying != playbutton.tag){
                    player = nil;
                }
                
                if(player == nil){
                    player = AVPlayer(URL: link)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FollowUpViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:player.currentItem)
                }
                if ((player.rate != 0)) {
                    player.pause()
                    image = UIImage(named: "play")?.imageWithRenderingMode(.AlwaysTemplate)
                }
                else{
                    image = UIImage(named: "pause")?.imageWithRenderingMode(.AlwaysTemplate)
                    self.CurrentPlaying=playbutton.tag;
                    player.play()
                   
                   
                }
                
                currentbutton.setImage(image, forState: .Normal)
                currentbutton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                
            }
            else{
                
                let image = UIImage(named: "play")?.imageWithRenderingMode(.AlwaysTemplate)
                currentbutton.setImage(image, forState: .Normal)
                currentbutton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                
            }
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        
        print("Playing Finished")
        
        for button in self.playButtons{
            if(self.CurrentPlaying == button.tag)
            {
                let image = UIImage(named: "play")?.imageWithRenderingMode(.AlwaysTemplate)
                button.setImage(image, forState: .Normal)
                button.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                self.player = nil;
            }
            
        }
        
        
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 153;
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                    isNewDataLoading = true
                    let param=Params(Limit:self.limit,gid:self.gid,offset:self.result.count,type:self.type,isfilter:false,isMore: true,isSync:false,filterpos: self.SeletedFilterpos)
                    Report(param: param, delegate: self).LoadData();
                    
                }
            }
        }
    }
    
   
    func showAlert(mesage :String){
        let alertView = UIAlertController(title: "MCube", message: mesage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" && options.count > 0{
            
            let popoverViewController = segue.destinationViewController as! menuViewController
            popoverViewController.FilterOptions=options;
            popoverViewController.SeletedFilter=SeletedFilterpos;
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
        }
        if segue.identifier == "detail"{
            
            let detailview = segue.destinationViewController as! DetailViewController
            detailview.currentData=CurrentData;
            detailview.type=self.type
            
        }
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func filterSelected(position: Int) {
        self.SeletedFilterpos=position;
        let option: OptionsData = self.options[position]
        self.gid=option.id!;
        let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:true,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
        self.isDownloading=true;
        self.showActivityIndicator()
        Report(param: param, delegate: self).LoadData();

        
    }
    
    func filteralert (){
        let option: OptionsData = self.options[SeletedFilterpos];
        let alertController = UIAlertController(title: "MCube", message:
            "No Records available for Group : \(option.value!)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.SeletedFilterpos=0;
            self.gid="0";
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();

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
            ModelManager.getInstance().deleteAllData();
            self.performSegueWithIdentifier("GoLogin", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
    func NoDataAlert (){
        let alertController = UIAlertController(title: "MCube", message:
            "No records available", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:false,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
            self.isDownloading=true;
            Report(param: param, delegate: self).LoadData();

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if self.showingActivity {
                self.navigationController?.view.hideToastActivity()
                self.showingActivity = !self.showingActivity
            }
            if self.refreshControll.refreshing{
                self.refreshControll.endRefreshing()
            }

        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: false, completion: nil)
        
    }
    func showActivityIndicator(){
        if !self.showingActivity {
            self.navigationController?.view.makeToastActivity(.Center)
        } else {
            self.navigationController?.view.hideToastActivity()
        }
        
        self.showingActivity = !self.showingActivity
        
    }
    
    
    
    func revealController(revealController: SWRevealViewController!,  willMoveToPosition position: FrontViewPosition){
        if(position == FrontViewPosition.Left) {
            self.mytableview.userInteractionEnabled = true
            sidebarMenuOpen = false
        } else {
            self.mytableview.userInteractionEnabled = false
            sidebarMenuOpen = true
        }
    }
    
    func revealController(revealController: SWRevealViewController!,  didMoveToPosition position: FrontViewPosition){
        if(position == FrontViewPosition.Left) {
            self.mytableview.userInteractionEnabled = true
            sidebarMenuOpen = false
        } else {
            self.mytableview.userInteractionEnabled = false
            sidebarMenuOpen = true
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(sidebarMenuOpen == true){
            return nil
        } else {
            return indexPath
        }
    }
    
    func setsection() {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("launchview") != nil{
            print("Loaded view")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("launchview")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if  NSUserDefaults.standardUserDefaults().stringForKey("track") == "1" {
                self.type="track"
                self.CurrentTitle="Track"
            }
            else if NSUserDefaults.standardUserDefaults().stringForKey("ivrs")  == "1"{
                self.type="ivrs"
                self.CurrentTitle="Ivrs"
            }
                
            else if NSUserDefaults.standardUserDefaults().stringForKey("pbx")  == "1"{
                self.type="x"
                self.CurrentTitle="MCubeX"
            }
                
            else if NSUserDefaults.standardUserDefaults().stringForKey("lead") == "1" {
                self.type="lead"
                self.CurrentTitle="Lead"
            }
                
            else if NSUserDefaults.standardUserDefaults().stringForKey("mtracker") == "1" {
                self.type="mtracker"
                self.CurrentTitle="MTracker"
            }
            else{
                self.type="followup"
                self.CurrentTitle="Followup"
            }
            
            
            
        }
        
    }
    
    
    var time: NSDate?
    
    func fetch(completion: () -> Void) {
        time = NSDate()
       // self.LoadData(false);
        completion()
    }
    
    func updateUI() {
        if let time = time {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .LongStyle
            print("Updated \(formatter.stringFromDate(time))")
          //  updateLabel?.text = formatter.stringFromDate(time)
        }
        else {
          print("Not yet updated")
        }
    }
    
    
    
}
