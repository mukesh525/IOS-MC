//  Created by Mukesh Jha on 03/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//
import UIKit
import Alamofire
import AVFoundation


class ReportViewController: UITableViewController,UIPopoverPresentationControllerDelegate,FilterSelectedDelegate ,SWRevealViewControllerDelegate,ReportDownload {
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
    var type:String=TRACK
    var isNewDataLoading:Bool=false;
    var player:AVPlayer!
    var CurrentTitle:String=TRACK.capitalizeIt()
    var isLogout:Bool=false;
    var CurrentData:Data!
    var showingActivity = false
    var CurrentPlaying:Int?
    var refreshControll = UIRefreshControl()
    var sidebarMenuOpen:Bool?
    
    
    @IBAction func LogoutTap(sender: UIBarButtonItem) {
        LogoutAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews()
    
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
        //print("Request failed with error: \(error)")
        if (error.code == -1009) {
            self.showAlert("No Internet Conncetion")
        }
        else if(error.code == -1001){
            self.showAlert("No Internet Conncetion")
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
        
        if(self.type != HISTORY){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.CurrentData = self.result[indexPath.row] as! Data
        self.performSegueWithIdentifier("detail", sender: self)
        }
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
               // self.showAlert("You clicked Play button \(indexPath.row)")
            }
            
        }
        cell.backgroundColor = UIColor.clearColor()
        if((data.audioLink?.isEmpty) != nil && NSString(string: data.audioLink!).length > 5){
            cell.playButton.hidden=false
        }else{
            cell.playButton.hidden=true
        }
        
        cell.callfrom.text=data.callFrom
        cell.callername.text=(data.callerName?.isEmpty) != nil && NSString(string: data.callerName!).length > 1 ?  data.callerName : UNKNOWN
        
        if((data.callTimeString?.isEmpty) != nil && NSString(string: data.callTimeString!).length > 1){
            cell.date.text=data.callTimeString!.getDateFromString()
            cell.time.text=data.callTimeString!.getTimeFromString()
            cell.status.text=(data.status?.isEmpty) != nil && NSString(string: data.status!).length > 1 ?  data.status : UNKNOWN
            
            cell.Group.text=data.groupName
            cell.groupLabel.text="Group"
            
        }
        else
        {
            cell.date.text=data.startTime!.getDateFromString()
            cell.time.text=data.startTime!.getTimeFromString()
            if((data.status?.isEmpty) != nil && NSString(string: data.status!).length > 0){
                cell.status.text=data.status == "0" ? MISSED: data.status == "1" ? INBOUND : OUTBOUND
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
        
        let url = "\(PLAY_URL)\(filename)"
        let link = NSURL(string: url)!
       for currentbutton in self.playButtons{
            if(currentbutton.tag == playbutton.tag ){
                var image:UIImage?
                if(self.CurrentPlaying != playbutton.tag){
                    player = nil;
                }
                
                if(player == nil){
                    player = AVPlayer(URL: link)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReportViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object:player.currentItem)
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
    
   
   
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == POPOVERSEGUE && options.count > 0{
            
            let popoverViewController = segue.destinationViewController as! FilterController
            popoverViewController.FilterOptions=options;
            popoverViewController.SeletedFilter=SeletedFilterpos;
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
        }
        if segue.identifier == DETAIL{
            
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
    
  
    
}
