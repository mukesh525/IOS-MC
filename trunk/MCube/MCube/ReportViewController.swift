//  Created by Mukesh Jha on 03/07/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//
import UIKit
import Alamofire
import AVFoundation
import MessageUI




class ReportViewController: UITableViewController,UIPopoverPresentationControllerDelegate,FilterSelectedDelegate ,OverflowSelectedDelegate,SWRevealViewControllerDelegate,ReportDownload,MFMessageComposeViewControllerDelegate,DismissalDelegate{
    @IBOutlet var mytableview: UITableView!
    @IBOutlet var extraButton: UIBarButtonItem!
    @IBOutlet var menubutton: UIBarButtonItem!
    let cellSpacingHeight: CGFloat = 5
    var result:NSMutableArray=NSMutableArray();
    var SeletedFilterpos: Int=0;
    var morePopOver:OverflowController!
    var isDownloading:Bool = false;
    var options :Array<OptionsData> = Array<OptionsData>()
   // var playButtons :Array<UIButton> = Array<UIButton>()
    var playButtons = [UIButton]()
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
      
    @IBAction func LogoutTap(_ sender: UIBarButtonItem) {
        LogoutAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        print("test")
    }
    
    func OnFinishDownload(_ result: NSMutableArray, options: Array<OptionsData>, param: Params) {
        self.isNewDataLoading = false
               if(param.isMore == true){
                self.result.addObjects(from: result as [AnyObject])
                }else{
                  self.result=result;
                 self.options=options;
                }
        
                if(self.result.count == 0 && param.isfilter == true){
                    self.hideProgress()
                    self.filteralert()
                }
                else if(self.result.count == 0 && param.isfilter == false){
                    self.hideProgress()
                    self.NoDataAlert()
        
                }
                else{
                    if self.refreshControll.isRefreshing{
                        self.refreshControll.endRefreshing()
                    }
        
                    else{
                        if(param.isMore==false){
                        self.hideProgress()
                        }
                    }
                    self.mytableview.reloadData()
                }
                   self.isDownloading=false;
        
    }

    


    
    
    
    func OnError(_ error: NSError) {
        self.isDownloading=false;
        self.isNewDataLoading=false;
        if self.refreshControll.isRefreshing{
            self.refreshControll.endRefreshing()
        }else{
            self.hideProgress()
        }
        //print("Request failed with error: \(error)")
        if (error.code == -1009) {
            self.showAlert("No Internet Conncetion")
        }
        else if(error.code == -1001){
            self.showAlert("No Internet Conncetion")
        }
    }
    

 
    
    override func viewWillAppear(_ animated: Bool) {
       self.playButtons=[UIButton]()
        self.tableView.reloadData()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result.count == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No Data Pull Down To Refresh"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "background_port.jpg"))
            return result.count
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.type != HISTORY){
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.CurrentData = self.result[(indexPath as NSIndexPath).row] as! Data
        self.performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!FollowupTableViewCell
        let data: Data = self.result[(indexPath as NSIndexPath).row] as! Data
        cell.layer.cornerRadius=15
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 2
        cell.playButton.tag=(indexPath as NSIndexPath).row
        cell.onButtonTapped = {
            if((data.audioLink?.isEmpty) != nil && NSString(string: data.audioLink!).length > 5){
                self.configurePlay(data.audioLink!,playbutton: cell.playButton)
            }else{
               // self.showAlert("You clicked Play button \(indexPath.row)")
            }
            
        }
        cell.onMoreTapped={ (sender) -> Void in
            let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: OVERFLOW))! as! OverflowController
            popoverContent.modalPresentationStyle = .popover
            if let popover = popoverContent.popoverPresentationController {
                let viewForSource = sender as! UIView
                popover.sourceView = viewForSource
                popover.sourceRect = viewForSource.bounds
                if(self.type == MTRACKER && (self.result[(indexPath as NSIndexPath).row] as! Data).location != "0.0,0.0"){
                    popoverContent.preferredContentSize = CGSize(width: 140,height: 133)
                } else{
                   popoverContent.preferredContentSize = CGSize(width: 140,height: 90)
                }
                popoverContent.delegate=self
                popoverContent.CurrentData=self.result[(indexPath as NSIndexPath).row] as! Data;
                popoverContent.Type=self.type
                popoverContent.dismissalDelegate = self
                popover.delegate = self
               
            }
            
            self.present(popoverContent, animated: true, completion: nil)

            
            
        }
        cell.backgroundColor = UIColor.clear
        if((data.audioLink?.isEmpty) != nil && NSString(string: data.audioLink!).length > 5 &&
            data.groupName != nil){
            cell.playButton.isHidden=false
            cell.playButton.tag=(indexPath as NSIndexPath).row
           if(self.playButtons.get((indexPath as NSIndexPath).row) != nil){
                self.playButtons[(indexPath as NSIndexPath).row]=cell.playButton
               }else{
                self.playButtons.append(cell.playButton)
               }

            
        }else{
            cell.playButton.isHidden=true
            
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
                cell.callFromlabel.text=data.status == "2" ? "Call To" : "Call From"
            }
            cell.Group.text=data.empName
            cell.groupLabel.text="Employee"
            
        }
        
        
        let image:UIImage!
        if(player != nil && (indexPath as NSIndexPath).row == CurrentPlaying){
           image = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
        }
        else{
            image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
            
        }
        cell.playButton.setImage(image, for: UIControlState())
        cell.playButton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        return cell
    }
    
    
    
    
    func configurePlay(_ filename:String,playbutton:UIButton) {
        print("play button size before \(self.playButtons.count)")
        let url = "\(PLAY_URL)\(filename)"
        //print(url)
        let unique = Array(Set(self.playButtons))
        print("play button size after sorting \(unique.count)")
        let link = URL(string: url)!
        for currentbutton in unique{
           // print ("TAG \(playbutton.tag)  ButtonTag \(currentbutton.tag)")
           if(currentbutton.tag == playbutton.tag ){
               // print ("TAG \(playbutton.tag)  ButtonTag \(currentbutton.tag)")
            
                var image:UIImage?
                if(self.CurrentPlaying != playbutton.tag){
                    player = nil;
                }
                
                if(player == nil){
                    player = AVPlayer(url: link)
                    NotificationCenter.default.addObserver(self, selector: #selector(ReportViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:player.currentItem)
                }
                if ((player.rate != 0)) {
                    player.pause()
                    image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
                }
                else{
                    image = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
                    self.CurrentPlaying=playbutton.tag;
                    player.play()
                   
                   
                }
                
                currentbutton.setImage(image, for: UIControlState())
                currentbutton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                
            }
            else{
                
                let image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
                currentbutton.setImage(image, for: UIControlState())
                currentbutton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                
            }
        }
    }
    
    func playerDidFinishPlaying(_ note: Notification) {
        print("Playing Finished")
        for button in self.playButtons{
            if(self.CurrentPlaying == button.tag)
            {
                let image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
                button.setImage(image, for: UIControlState())
                button.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                self.player = nil;
                self.CurrentPlaying=nil;
            }
            
        }
        
        
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153;
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
    
   
   
    func overflowSelected(_ position: Int, CurrentData: Data) {
        
        if(position == 0){
            UIApplication.shared.openURL(NSURL(string: "tel://\(CurrentData.callFrom!)")! as URL)
        }
        else if(position == 2){
            self.CurrentData=CurrentData;
            self.performSegue(withIdentifier: LOCATE, sender: self)
        }
        else{
           self.sendSms(CurrentData)
        }
        
        
    }
    
    func sendSms(_ CurrentData: Data){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [CurrentData.callFrom!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }

    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func onFilterTapped(_ sender: Any) {
        
        //print("Filter Clicked")
        if(options.count>0){
        self.performSegue(withIdentifier: POPOVERSEGUE, sender: self)
        }

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    if segue.identifier == POPOVERSEGUE && options.count > 0{
           let popoverViewController = segue.destination as! FilterController
            popoverViewController.preferredContentSize = CGSize(width: 320, height: 186);         popoverViewController.FilterOptions=options;
            popoverViewController.SeletedFilter=SeletedFilterpos;
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
        }
       else if segue.identifier == DETAIL{
            
            let detailview = segue.destination as! DetailViewController
            detailview.currentData=CurrentData;
            detailview.type=self.type
            
        }
        else if segue.identifier == LOCATE{
         let mapView = segue.destination as! MapController
         mapView.currentdata=CurrentData;
        }
        
        
        
                
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func filterSelected(_ position: Int) {
        self.SeletedFilterpos=position;
        let option: OptionsData = self.options[position]
        self.gid=option.id!;
        let param=Params(Limit: self.limit,gid:self.gid,offset:self.offset,type:self.type,isfilter:true,isMore: false,isSync:false,filterpos: self.SeletedFilterpos)
        self.isDownloading=true;
        self.showProgress()
        Report(param: param, delegate: self).LoadData();

        
    }
    
   
//       func showActivityIndicator(){
//        if !self.showingActivity {
//            showProgress()
//           // self.navigationController?.view.makeToastActivity(.center)
//           
//        } else {
//            hideProgress()             // self.navigationController?.view.hideToastActivity()
//            
//        }
//        
//        self.showingActivity = !self.showingActivity
//        
//    }
    
    
    func showProgress(){
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.contentColor=UIColor.black
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        spinnerActivity.isUserInteractionEnabled = false;
        self.navigationController?.view.isUserInteractionEnabled = false;
    
    
    }
    
    
    func hideProgress(){
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
        self.navigationController?.view.isUserInteractionEnabled = true;
    }
    
    
    
    func revealController(_ revealController: SWRevealViewController!,  willMoveTo position: FrontViewPosition){
        if(position == FrontViewPosition.left) {
            self.mytableview.isUserInteractionEnabled = true
            sidebarMenuOpen = false
            //change image menu
            _ = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
           // menubutton.setBackgroundImage(backimage, for: .normal, barMetrics: UIBarMetrics.default)
        } else {
            self.mytableview.isUserInteractionEnabled = false
            sidebarMenuOpen = true
            //change image arrow
            _ = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
          //  menubutton.setBackgroundImage(backimage, for: .normal, barMetrics: UIBarMetrics.default)
           
          
            
            for currentbutton in self.playButtons{
                if(currentbutton.tag == self.CurrentPlaying ){
                    self.player=nil;
                    let image = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
                    currentbutton.setImage(image, for: UIControlState())
                    currentbutton.tintColor = UIColor(red: 255.0/255.0, green: 87.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }

            
            }
            
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!,  didMoveTo position: FrontViewPosition){
        if(position == FrontViewPosition.left) {
            self.mytableview.isUserInteractionEnabled = true
            sidebarMenuOpen = false
            //back arrow
            _ = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
           // menubutton.setBackgroundImage(backimage, for: .normal, barMetrics: UIBarMetrics.default)
        } else {
            self.mytableview.isUserInteractionEnabled = false
          //  sidebarMenuOpen = true 
            //menu image
            _ = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
           // menubutton.setBackgroundImage(backimage, for: .normal, barMetrics: UIBarMetrics.default)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if(sidebarMenuOpen == true){
            return nil
        } else {
            return indexPath
        }
    }
    
      func finishedShowing(_ viewController: UIViewController) {
       viewController.dismiss(animated: true, completion: nil)
       self.performSegue(withIdentifier: "locate", sender: self)
     
        
    }
    
}
